require "../../utils"
require "../../config"

module DppmRestApi::Actions::Pkg
  extend self
  ALL_PKGS = root_path
  ONE_PKG  = root_path "/:id"
  # List built packages
  get ALL_PKGS do |context|
    if context.current_user? && has_access? context, Access::Read
      # TODO: list all built packages
    end
    deny_access! to: context
  end
  # Clean unused built packages
  delete ALL_PKGS do |context|
    if context.current_user? && has_access? context, Access::Delete
      # TODO: delete all unused built packages
    end
    deny_access! to: context
  end
  # Query information about a given package
  get ONE_PKG do |context|
    if context.current_user? && has_access? context, Access::Read
      # TODO: Query information about the given package
    end
    deny_access! to: context
  end
  # Delete a given package
  delete ONE_PKG do |context|
    if context.current_user? && has_access? context, Access::Delete
      # TODO: Query information about the given package
    end
    deny_access! to: context
  end

  module Build
    # Build a package, returning the ID of the built image, and perhaps a status
    # message? We could also use server-side events or a websocket to provide the
    # status of this action as it occurs over the API, rather than just returning
    # a result on completion.
    post (root_path "/:package") do |context|
      pkg_id = context.params.url["package"]?
      if context.current_user? && Pkg.has_access? context.current_user, Access::Create, pkg_id
        # TODO: build the package based on the submitted configuration
      end
      deny_access! to: context
    end
  end
end
