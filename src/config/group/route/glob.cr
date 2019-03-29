require "./glob/*"

module DppmRestApi
  struct Route
    # The pattern by which to match the path.
    struct Glob
      # The parts of this route glob
      property parts : Array(Part)

      # Read in a series of slash-separated globs, which *should* start with a
      # leading slash but is not required to.
      def initialize(from text : String)
        @parts = text.split('/').map { |section| Part.new from: section }
      end

      def to_s
        '/' + parts.join '/'
      end

      def to_json(indent level : String | Int = nil)
        JSON.build(indent: level) { |builder| builder.string to_s }
      end

      def to_json(io : IO, indent level : String | Int = nil)
        JSON.build io, indent: level do |builder|
          builder.string to_s
        end
      end

      def self.from_json(io : IO) : self
        new parser: JSON::PullParser.new io
      end

      def self.new(parser pull : JSON::PullParser) : self
        if text = pull.read? String
          new from: text
        else
          raise JSON::ParseException.new "expected #{pull.raw_value} to be a string", pull.line_number, pull.column_number
        end
      end

      # Yields the pair of each `{ part, index }` to the block, returning false
      # if any block returns a falsey value.
      def all_parts?
        @parts.each_with_index { |part, i| return false unless yield part, i }
        true
      end

      # Matches the given text to this glob.
      def match?(text : String)
        test_parts = text.split '/'
        all_parts? do |part, idx|
          case part.match? test_parts[idx]?
          when Part::MatchStatus::DoesNotMatch       then false
          when Part::MatchStatus::RecursivelyMatches then return true
          when Part::MatchStatus::Matches            then true
          end
        end && (test_parts.size == @parts.size)
      end
    end
  end
end
