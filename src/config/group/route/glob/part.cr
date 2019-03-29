module DppmRestApi
  struct Route
    struct Glob
      # One part of the path glob. Accepted glob types are:
      #
      # - A string literal (with the exception of the following rules) will
      #   match the exact given path section.
      # - A series of string literals, surrounded by curly (`{}`) braces and
      #   separated by commas (`,`) will match any of the strings. For
      #   example, `{a,b,c}` would match the path part `a`, `b`, *or* `c`
      # - A single asterisk (`*`) will match any string.
      # - A pair of asterisks (`**`) will match all of the remaining path
      #   sections.
      abstract struct Part
        enum MatchStatus : UInt8
          DoesNotMatch; Matches; RecursivelyMatches
        end

        def self.new(from text : String)
          case text
          when "*"               then MatchAny.new
          when "**"              then MatchRecursiveAny.new
          when .starts_with? "{" then MatchMany.new from: text
          else                        MatchSpecific.new matching: text
          end
        end

        abstract def to_s : String
        abstract def match?(text : String) : MatchStatus

        def match?(null_value : Nil) : MatchStatus
          MatchStatus::DoesNotMatch
        end
      end
    end
  end
end
