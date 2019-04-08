require "./route"

module DppmRestApi
  # A collection of routes.
  struct Routes
    # The routes collection is mapped to JSON as an object, but internally,
    # there's no reason/way to sort it, so it's an array of this struct rather
    # than a hash. An `Entry` represents the pair that is the glob and the route
    # that is associated with it in the configuration.
    record Entry, glob : String, route : Route do
      # Returns true if the glob matches (using `::File.match?`) *and* its
      # `#route` property's `#match?` method returns true.
      def match?(path, query)
        return false unless File.match? @glob, path
        @route.match? query
      end

      def initialize(@glob, permissions, query_parameters)
        @route = Route.new permissions, query_parameters
      end
    end
    include Enumerable(Entry)

    # :nodoc:
    property internal_data : Array(Entry)

    # :nodoc:
    def initialize(@internal_data); end

    # Yield an entry to the block -- which has `#glob` and `#route` attributes.
    def each
      internal_data.each do |entry|
        yield entry
      end
    end

    delegate :<<, to: internal_data

    def add(glob : String,
            permissions : Access,
            query_parameters : Hash(String, Array(String)))
      @internal_data << Entry.new glob, permissions, query_parameters
    end

    def self.from_json(io : IO)
      new pull: JSON::PullParser.new io
    end

    def self.new(pull parser : JSON::PullParser)
      data = [] of Entry
      parser.read_object do |glob|
        data << Entry.new glob, Route.new parser
      end
      new data
    end

    def to_json(io : IO)
      JSON.build io do |builder|
        to_json builder
      end
    end

    def to_json(builder : JSON::Builder)
      builder.object do
        each do |entry|
          builder.field entry.glob do
            entry.route.to_json builder
          end
        end
      end
    end
  end
end
