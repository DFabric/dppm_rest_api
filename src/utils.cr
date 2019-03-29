require "kemal"
require "kemal_jwt_auth"
require "./config/users"

# Render the given data as JSON to the local `context` variable.
macro render_data(data)
  context.response.content_type = "application/json"
  IO.copy {{data.id}}, context.response
end

macro root_path(route = nil, &block)
  {{
    "/" + @type.stringify
      .downcase
      .gsub(/^DppmRestApi::Actions::/, "")
      .gsub(/::/, "/") + (route || "")
  }}
end

def deny_access!(to context)
  context.response.status_code = 401
  context.response.write "Forbidden.".to_slice
  context.response.flush
  context
end

private def deserialize(groups maybe_nil : String?)
  if groups = maybe_nil
    groups.split(",").map &.to_i
  end
end

# returns true if the given user has access to the given context with the given
# permission type
def has_access?(context : HTTP::Status::Context, permission : DppmRestApi::Access)
  verb = Group::Route::HTTPVerb.from_s(context.request.method)
  if groups = deserialize context.current_user?.try { |user| user["groups"]? }
    groups.each do |group|
      if found = DppmRestApi.config.file.groups.find { |g| g.id == group }
        return true if found.can_access? verb, context.request.path, permission
      end
    end
  end
  false
end

alias JWTCompatibleHash = Hash(String, String | Int32 | Bool?)

macro throw(message, *format, status_code = 500)
  context.response.status_code = {{status_code.id}}
  context.response.puts sprintf {{message}}, {{format.splat.id}}
  context.response.flush
  context
end
