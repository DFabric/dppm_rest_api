module DppmRestApi
  struct Route
    struct Glob
      # A matcher which will match this part and any future parts.
      struct MatchRecursiveAny < Part
        def initialize; end

        def to_s
          "**"
        end

        def match?(text : String)
          MatchStatus::RecursivelyMatches
        end
      end
    end
  end
end
