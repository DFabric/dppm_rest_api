require "json"

module DppmRestApi
  struct User
    API_KEY_SIZE = 63_u8
    include JSON::Serializable
    property api_key_hash : Scrypt::Password
    property groups : Array(String)
    property name : String

    def initialize(@api_key_hash,
                   @role,
                   @owned_apps,
                   @owned_pkgs,
                   @owned_services,
                   @owned_srcs); end

    def self.new(api_key_hash, role)
      new api_key_hash, role, [] of String, [] of String, [] of String, [] of String
    end

    def self.create(role : String) : {String, self}
      api_key = Random::Secure.base64 API_KEY_SIZE
      {api_key, new(Scrypt::Password.create(api_key), role)}
    end

    def to_h : JWTCompatibleHash
      {% begin %}
      JWTCompatibleHash{
        "groups" => serialized_groups,
        "name" => @name
      }
      {% end %}
    end

    private def serialized_groups : String
      groups.join(",")
    end
  end
end
