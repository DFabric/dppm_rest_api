require "./part"

module DppmRestApi
  struct Route
    struct Glob
      struct MatchPartialWildcard < Part
        property wildcard_position : WildcardPosition
        property text : String
        property raw_value : String?

        def initialize(@wildcard_position, @text); end

        def self.new(from text)
          if text.starts_with? '*'
            new WildcardPosition::Left, text.lchop
          elsif text.ends_with? '*'
            new WildcardPosition::Right, text.rchop
          else
            raise InvalidInput.new text + " should have started or ended with *."
          end
        end

        def to_s
          @raw_value ||= if wildcard_position.left?
                           "*" + @text
                         else
                           @text + "*"
                         end
        end

        def match?(text : String) : Bool
          if wildcard_position.left?
            text.ends_with? @text
          else
            text.starts_with? @text
          end
        end

        enum WildcardPosition : UInt8
          Left, Right
        end
      end
    end
  end
end
