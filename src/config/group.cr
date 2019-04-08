require "./access"
require "./route"

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
    property permissions : Array(Route)

    # returns true if members of this group may access a request on the given
    # route, with the given permission level.
    def can_access?(verb, path, permission : Access) : Bool
      if access = permissions
           .select { |route| route.verb == verb }
           .find { |route| route.match? verb, path }
           .try &.permissions
        access.value & permission.value > 0
      else
        false
      end
    end

    def initialize(@name, @id, @permissions); end

    @@counter = 0

    def self.new(name)
      new name, (@@counter += 1), DEFAULT_PERMISSIONS
    end

    DEFAULT_PERMISSIONS = {Route.new("/**") => Access.deny}
  end
end
