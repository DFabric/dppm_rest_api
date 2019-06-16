macro initialize_error_handlers
  {% for code in HTTP::Status.constants %}
  Kemal.config.add_error_handler HTTP::Status::{{code.id}}.value do |context, exception|
    # TODO: a better logging solution
    log "ERROR@#{Time.utc}: #{exception.message}"
    {errors: [exception.message]}.to_json context.response
    context.response.flush
  end
  {% end %}
end
