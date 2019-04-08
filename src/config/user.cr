require "json"

module DppmRestApi
  struct User
    API_KEY_SIZE = 63_u8
    include JSON::Serializable
    property api_key_hash : Scrypt::Password
    property groups : Array(Int32)
    property name : String

    def initialize(@api_key_hash,
                   @groups,
                   @name); end

    def self.create(groups : Array(Group), name : String) : {String, self}
      api_key = Random::Secure.base64 API_KEY_SIZE
      {api_key, new(Scrypt::Password.create(api_key), groups.map { |g| g.id }, name)}
    end

    def to_h : JWTCompatibleHash
      JWTCompatibleHash{
        "groups" => serialized_groups,
        "name"   => @name,
      }
    end

    private def serialized_groups : String
      groups.map(&.to_s base: 16).join(",")
    end

    def self.deserialize(groups : String)
      groups.split(',').map { |id| id.to_i base: 16 }
    end
  end
end
