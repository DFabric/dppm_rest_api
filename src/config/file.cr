require "./users"

module DppmRestApi
  struct Config
    struct File
      include JSON::Serializable
      property groups : Array(Group)
      property users : Array(User)
    end
  end
end
