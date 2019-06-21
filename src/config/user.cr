require "json"
require "./group"

struct DppmRestApi::Config::User
  API_KEY_SIZE = 63_u8
  include JSON::Serializable
  property api_key_hash : Scrypt::Password
  getter group_ids : Set(Int32)
  property name : String
  # :nodoc:
  class_property all_groups : Array(Group) = Array(Group).new

  def groups : Array(Group)
    @@all_groups.select { |group| @group_ids.includes? group.id }
  end

  def initialize(@api_key_hash,
                 @group_ids : Set(Int32),
                 @name : String)
  end

  def self.new(api_key_hash string : String, groups, name)
    new Scrypt::Password.new(string), groups.to_set, name
  end

  @[AlwaysInline]
  def self.create(groups : Set(Group), name : String) : {String, self}
    create groups.map { |g| g.id }, name
  end

  def self.create(groups : Set(Int), name : String) : {String, self}
    api_key = Random::Secure.base64 API_KEY_SIZE
    {api_key, new(Scrypt::Password.create(api_key), groups, name)}
  end

  def to_h : JWTCompatibleHash
    JWTCompatibleHash{"groups"       => serialized_groups,
                      "name"         => @name,
                      "API key hash" => api_key_hash.to_s}
  end

  def self.from_h(hash data : JWTCompatibleHash)
    if (groups = data["groups"]?).is_a?(String) &&
       (name = data["name"]?).is_a?(String) &&
       (key = data["API key hash"]?).is_a? String
      new key, deserialize(groups), name
    end
  rescue ArgumentError
    nil
  end

  private def serialized_groups : String
    groups.map(&.id.to_s base: 16).join(",")
  end

  def self.deserialize(groups : String)
    groups.split(',').map { |id| id.to_i base: 16 }
  end

  # Yields each Group to the block for which the user is a member of.
  def each_group : Nil
    groups.each { |group| yield group }
  end

  # yields each Group that the user is a member of to the block, and returns
  # an Iterator of the results of the block. Important: if the result of the
  # block is nil, it will be ignored (i.e. not a member of the resulting
  # array) -- hence the resulting array can be of a different size than the
  # number of groups of which this user is a member.
  def map_groups(&block : Group -> R) forall R
    Iterator.of do
      each_group { |group| yield group }
      yield Iterator.stop
    end.reject &.nil?
  end

  # Yield each group to a block and return the first group for which the block
  # returns a truthy value
  def find_group?
    each_group { |group| return group if yield group }
  end

  def join_group(id : Int32)
    @group_ids << id
  end

  def leave_group(id : Int32)
    @group_ids.delete id
  end

  def to_pretty_s
    "Name: #{name}; Member of: #{group_ids.join(", ")}"
  end
end

alias JWTCompatibleHash = Hash(String, String | Int32 | Bool?)
