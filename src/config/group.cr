require "./access"
require "./routes"

module DppmRestApi
  # A group represents an access role that a user may be a member of.
  struct Group
    include JSON::Serializable
    include JSON::Serializable::Strict
    # The human-readable name of the `Group`. This *should* be unique.
    property name : String
    # The identifier used to refer to this `Group`. This *must* be unique.
    property id : Int32
    # All route-matching globs associated with this `Group`, mapped to the
    # group's permission level.
    property permissions : Routes

    # returns true if members of this group may access a request on the given
    # route, with the given permission level.
    def can_access?(path, query, permission : Access) : Bool
      maybe_nil_perms = permissions
        .find(&.match? path, query)
        .try(&.route.access)
      if access = maybe_nil_perms
        return access.value & permission.value > 0
      end
      false
    end

  def can_access?(context : HTTP::Server::Context, permissions : Access) : Bool
      can_access?(
        context.request.path,
        HTTP::Params.parse(context.request.query || ""),
        permissions)
    end

    def initialize(@name, @id, @permissions); end

    @@counter = 0

    def self.new(name : String)
      new name, DEFAULT_PERMISSIONS
    end

    def self.new(name : String, permissions : Routes::Entry)
      new name, (@@counter += 1), permissions
    end

    DEFAULT_PERMISSIONS = Routes::Entry.new(
      glob: "/**",
      permissions: Access::Deny,
      query_parameters: {"namespace" => ["**"]}
    )
  end
end
