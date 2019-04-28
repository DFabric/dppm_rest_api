require "../../config"
require "../../utils"

module DppmRestApi::Actions::Src
  extend self
  relative_get "" do |context|
    if context.current_user? && has_access? context, Access::Read
      # TODO: List all available source packages
    end
    deny_access! to: context
  end
  # List all available source packages, of either the *lib* or *app* type.
  relative_get "/:type" do |context|
    if context.current_user? && has_access? context, Access::Read
      # TODO: List available source packages
    end
    deny_access! to: context
  end
end
