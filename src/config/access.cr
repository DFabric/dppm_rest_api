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

    def self.new(pull : JSON::PullParser)
      from_value pull.read_int
    end

    def to_json
      value
    end

    def self.from_json(value : Number)
      from_value number
    end

    def self.from_value(value : Int)
      raise "invalid variant of Access recieved: #{value}" if value > Access::All.value || value < 0
      variant = Access::None
      {% for variant in @type.constants %}
      variant |= {{variant.id}} if (value & {{variant.id}}.value) > 0
      {% end %}
      variant
    end
  end
end
