require "./part"

module DppmRestApi
  struct Route
    struct Glob
      # A matcher for a single string literal glob part.
      struct MatchSpecific < Part
        property text : String

        def initialize(matching @text); end

        delegate to_s, to: text

        def match?(text : String)
          text == @text
        end
      end
    end
  end
end
