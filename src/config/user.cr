require "json"

module DppmRestApi
  struct User
    API_KEY_SIZE = 63_u8
    include JSON::Serializable
    property api_key_hash : Scrypt::Password
    # The IDs of the groups this user is a member of.
    property groups : Array(Int32)
    # The human-readable name of this user.
    property name : String

    def initialize(@api_key_hash : Scrypt::Password,
                   @groups : Array(Int32),
                   @name : String); end

    # Create a new user from a given raw Scrypt hash, group list, and name.
    def self.new(api_key_hash string : String, groups, name)
      new Scrypt::Password.new(string), groups, name
    end

    # Create a new user with a new random API key, returning the pair of the
    # Base64-encoded API key and the User struct that will be able to use that
    # authentication key. This is the **ONLY** case where the application will
    # give a user their API key in plaintext -- after the garbage collector
    # gathers the API key from this method there is no other means of retrieving
    # it besides relying on the user to not lose their key.
    def self.create(groups : Array(Group), name : String) : {String, self}
      api_key = Random::Secure.base64 API_KEY_SIZE
      {api_key, new(Scrypt::Password.create(api_key), groups.map { |g| g.id }, name)}
    end

    # serialize this User in such a way that it can be stored in a JWT
    def to_h : JWTCompatibleHash
      JWTCompatibleHash{"groups"       => serialized_groups,
                        "name"         => @name,
                        "API key hash" => api_key_hash.to_s}
    end

    # Recreate the user from the data stored within the encrypted JWT and
    # passed to the user.
    def self.from_h(hash data : JWTCompatibleHash)
      if (groups = data["groups"]?).is_a?(String) &&
         (name = data["name"]?).is_a?(String) &&
         (key = data["API key hash"]?).is_a? String
        new key, (deserialize groups), name
      end
    rescue ArgumentError
      nil
    end

    private def serialized_groups : String
      groups.map(&.to_s base: 16).join(",")
    end

    def self.deserialize(groups : String) : Array(Int32)
      groups.split(',').map { |id| id.to_i base: 16 }
    end

    # Yields each Group to the block for which the user is a member of.
    def each_group(&block : Group -> _) : Void
      groups.each do |id|
        if group = DppmRestApi.config.file.groups[id]?
          yield group
        else
          DppmRestApi.config.logger.warn "user #{name} is a member of an invalid group ##{id}"
        end
      end
    end

    # yields each Group that the user is a member of to the block, and returns
    # an Iterator of the results of the block. Important: if the result of the
    # block is nil, it will be ignored (i.e. not a member of the resulting
    # iterator) -- hence the resulting iterator can be of a different size than
    # the number of groups of which this user is a member.
    def map_groups(&block : Group -> R) : Iterator(R) forall R
      Iterator.of { each_group { |group| yield group } }.reject &.nil?
    end

    # Yield each group to a block and return the first group for which the block
    # returns a truthy value
    def find_group?
      each_group { |group| return group if yield group }
    end
  end
end
