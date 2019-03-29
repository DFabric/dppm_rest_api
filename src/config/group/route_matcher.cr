require "../../errors/implementation_error"
require "./route/glob"
require "../access"

module DppmRestApi
  # Matches a request to a series of globs loaded from a config file.
  struct Route
    include JSON::Serializable
    # The HTTP verbs/methods used by the routes in this API.
    enum HTTPVerb : UInt8
      OPTIONS
      GET
      POST
      PUT
      DELETE
    end
    # The HTTP verb/method associated with this route-matcher.
    property verb : HTTPVerb
    # The glob pattern used to represent the permitted (or denied) paths
    # represented by this entry
    property path_pattern : Glob
    # The permission/access level for this route
    property permissions : Access

    # Returns true if this Route matches the given path and verb.
    def match?(verb : HTTPVerb, path : String)
      return false unless verb == @verb
      path_pattern.match? path
    end
  end
end
