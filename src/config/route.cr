require "../errors/invalid_input"
require "./access"

module DppmRestApi
  # Matches a request to a series of globs loaded from a config file.
  struct Route
    include JSON::Serializable
    # The HTTP verbs/methods used by the routes in this API.
    @[Flags]
    enum HTTPVerb : UInt8
      OPTIONS
      GET
      POST
      PUT
      DELETE

      def to_json(builder)
        builder.string to_s
      end

      def self.from_json(pull parser : JSON::PullParser) : self
        if verb = parse? parser.read_string?
          verb
        else
          lin, col = parser.line_number, parser.column_number
          raise JSON::ParseException.new "expected #{parser.read_raw} to be a string", lin, col
        end
      end
    end
    # The HTTP verb/method associated with this route-matcher.
    property verb : HTTPVerb
    # The glob pattern used to represent the permitted (or denied) paths
    # represented by this entry
    @[JSON::Field(key: "path pattern")]
    property path_pattern : String
    # The permission/access level for this route
    property permissions : Access

    def initialize(@verb, @path_pattern, @permissions); end

    # Returns true if this Route matches the given path and verb.
    def match?(verb : HTTPVerb, path : String)
      return false unless verb == @verb
      File.match? path_pattern, path
    end
  end
end
