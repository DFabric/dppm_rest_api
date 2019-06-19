# :nodoc:
module ErrorHandlerHelpers
  extend self

  def messages_from(error : Exception)
    messages = [response_data_for error]
    while error = error.cause
      messages << response_data_for error
    end
    messages
  end

  def response_data_for(error : Exception)
    if error.responds_to? :status_code
      # expected error handler type
      {
        type:        error.class.to_s,
        message:     error.message,
        status_code: error.status_code,
      }
    else
      # any generic exception
      {
        type:    error.class.to_s,
        message: error.message,
      }
    end
  end
end

macro initialize_error_handlers
  {% for code in HTTP::Status.constants %}
  if HTTP::Status::{{code}}.value >= 400
    Kemal.config.add_error_handler HTTP::Status::{{code.id}}.value do |context, exception|
      # TODO: a better logging solution
      log "ERROR@#{Time.utc}: #{exception.message}"
      context.response.status_code = exception.status_code.value if exception.responds_to? :status_code
      {errors: ErrorHandlerHelpers.messages_from exception}.to_json context.response
      context.response.flush
      nil
    end
  end
  {% end %}
end
