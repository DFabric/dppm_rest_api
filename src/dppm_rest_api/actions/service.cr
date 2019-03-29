require "../../config"
require "../../utils"

module DppmRestApi::Actions::Service
  extend self
  # List the managed services. The `system` query parameter may be specified to
  # enumerate all system services rather than just the ones managed by DPPM.
  get root_path do |context|
    if context.current_user? && has_access? context, Access::Read
    end
    deny_access! to: context
  end
  # List each managed service along with its status output.
  get (root_path "/status") do |context|
    if context.current_user? && has_access? context, Access::Read
    end
    deny_access! to: context
  end
  # start the service associated with the given application
  put (root_path "/:service/boot") do |context|
    service = context.params.url["service"]?
    if context.current_user? && has_access? context, Access::Update
    end
    deny_access! to: context
  end
  # reload the service associated with the given application
  put (root_path "/:service/reload") do |context|
    service = context.params.url["service"]?
    if context.current_user? && has_access? context, Access::Update
    end
    deny_access! to: context
  end
  # restart the service associated with the given application
  put (root_path "/:service/restart") do |context|
    service = context.params.url["service"]?
    if context.current_user? && has_access? context, Access::Update
    end
    deny_access! to: context
  end
  # start the service associated with the given application
  put (root_path "/:service/start") do |context|
    service = context.params.url["service"]?
    if context.current_user? && has_access? context, Access::Update
    end
    deny_access! to: context
  end
  # get the status of the service associated with the given application
  get (root_path "/:service/status") do |context|
    service = context.params.url["service"]?
    if context.current_user? && has_access? context, Access::Read
    end
    deny_access! to: context
  end
  # stop the service associated with the given application
  put (root_path "/:service/stop") do |context|
    service = context.params.url["service"]?
    if context.current_user? && has_access? context, Access::Update
    end
    deny_access! to: context
  end
end
