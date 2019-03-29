require "./part"

module DppmRestApi
  struct Route
    struct Glob
      # A matcher which matches anything.
      struct MatchAny < Part
        def initialize; end

        def to_s
          "*"
        end

        def match?(text : String)
          MatchStatus::Matches
        end
      end
    end
  end
end
