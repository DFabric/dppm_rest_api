macro initialize_error_handlers
  {% for code in HTTP::Status.constants %}
  if HTTP::Status::{{code}}.value >= 400
    Kemal.config.add_error_handler HTTP::Status::{{code.id}}.value do |context, exception|
      # TODO: a better logging solution
      log "ERROR@#{Time.utc}: #{exception.message}"
      context.response.status_code = exception.status_code.value if exception.responds_to? :status_code
      {errors: [exception.message]}.to_json context.response
      context.response.flush
      nil
    end
  end
  {% end %}
end
