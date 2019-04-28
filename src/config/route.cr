require "../errors/invalid_input"
require "./access"

module DppmRestApi
  # Matches a request to a series of globs loaded from a config file.
  struct Route
    # The permission/access level for this route
    property access : Access

    property query_parameters : Hash(String, String)

    def initialize(pull parser : JSON::PullParser)
      access_is_set, query_parameters_are_set = false, false
      access = uninitialized Access
      query_parameters = uninitialized Hash(String, String)
      parser.read_object do |key|
        case key
        when "access"
          access = Access.new parser
          access_is_set = true
        when "query_parameters"
          query_parameters = Hash(String, String).new parser
          query_parameters_are_set = true
        end
      end
      unless access_is_set
        raise JSON::ParseException.new("access must be set",
          parser.line_number, parser.column_number)
      end
      unless query_parameters_are_set
        query_parameters = {} of String => String
      end
      @access = access
      @query_parameters = query_parameters
    end

    def initialize(@access, @query_parameters); end

    # Returns true if this Route matches the given verb, and query
    # parameters. Does not imply a matching access.
    def match?(parameters : HTTP::Params)
      all_match = true
      query_parameters.each do |key, glob|
        if param = parameters[key]?
          all_match = false unless File.match? glob, param
        else
          all_match = false
        end
      end
      all_match
    end
  end
end
