require "./part"

module DppmRestApi
  struct Route
    struct Glob
      # A part matcher for many options.
      #
      # I.E. for the glob `{ app,pkg ,service}`, this matcher would match
      # `"app"`, `"pkg"`, amd `"service"`. but nothing else.
      struct MatchMany < Part
        property values : Array(String)
        @text : String?

        def initialize(@values, @text = nil)
        end

        def self.new(from text : String)
          new text.lchop.rchop.split(",").map(&.strip), text
        end

        def to_s
          @text ||= "{" + @values.join(",") + "}"
        end

        def match?(text : String)
          if @values.find { |option| option === text }
            MatchStatus::Matches
          else
            MatchStatus::DoesNotMatch
          end
        end
      end
    end
  end
end
