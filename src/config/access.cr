module DppmRestApi
  @[Flags]
  enum Access : UInt8
    Create; Read; Update; Delete

    def self.super_user
      Access::All
    end

    def self.deny
      Access::None
    end

    def self.new(value : Number)
      new value.to_u8
    end

    def to_json(builder : JSON::Builder)
      builder.string to_s
    end

    def to_json(io : IO)
      JSON.build io do |builder|
        to_json builder
      end
    end

    private def self.parse_strings?(iter : Array(String))
      verb = Access::None
      iter.each do |str|
        if val = parse? str
          verb |= val
        end
      end
      return verb
    end

    # Parses an Access from a JSON document. The entry in the document may be
    # a string, array of strings, or an integer value. If it is a string, it may
    # be specified like `"Create | Read"` with pipes ("|") separating variants.
    #
    # An array of strings are each parsed as if they were an individual string
    # entry, and then their values will be combined (bitwise-or'd). An integer
    # value will simply be taken as the numeric value of the variant:
    # ```
    # Create: 1
    # Read: 2
    # Update: 4
    # Delete: 8
    # ```
    # or the bitwise-or'd combination of the above.
    #
    # So one could deny access to all routes by specifying any of `0`, `"None"`,
    # or `["None"]`. One could allow access to all routes by specify ing any of
    # `15`, `"All"`, or even `"Create | Read | Update | Delete"` or
    # `["Create", "Read", "Update", "Delete"]`.
    def self.new(pull parser : JSON::PullParser) : self
      case parser.kind
      when :string
        if verb = parse_strings? parser.read_string.split('|').map(&.strip)
          puts "parsed verb #{verb.inspect}"
          return verb
        else
          raise JSON::ParseException.new "failed to parse string",
            parser.line_number,
            parser.column_number
        end
      when :begin_array
        ary = [] of String
        parser.read_array do
          ary << parser.read_string
        end
        parse_strings? ary
      when :int
        inst = new parser.read_int
        puts "parsed verb #{inst.inspect}"
        inst
      else
        pp! parser.kind, parser.raw_value, parser.string_value, parser.read_raw
        lin, col = parser.line_number, parser.column_number
        raise JSON::ParseException.new <<-MSG, lin, col
          expected #{parser.raw_value} to be a string, integer between 0 and
          #{Access::All.value}, or array of strings
          MSG
      end
    end

    # :ditto:
    def self.from_json(io : IO)
      new pull: JSON::PullParser.new io
    end
  end
end
