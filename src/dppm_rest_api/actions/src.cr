require "../../config"
require "../../utils"

module DppmRestApi::Actions::Src
  extend self
  get root_path do |context|
    if context.current_user? && has_access? context, Access::Read
      # TODO: List all available source packages
      next context
    end
    deny_access! to: context
  end
  # List all available source packages, of either the *lib* or *app* type.
  get (root_path "/:type") do |context|
    if context.current_user? && has_access? context, Access::Read
      # TODO: List available source packages
      next context
    end
    deny_access! to: context
  end
end
