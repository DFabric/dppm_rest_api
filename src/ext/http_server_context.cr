require "kemal"

class HTTP::Server
  class Context
    property errors = [] of String

    def error!(message : String, status_code : Int? = nil)
      response.status_code = status_code if status_code
      errors << message
    end
  end
end
