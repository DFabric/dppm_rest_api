require "./spec_helper"

describe "#deny_access!" do
  it "denies access" do
    backing_io, ctx = new_test_context
    deny_access! to: ctx
    ctx.response.status_code.should eq 401
    # ctx.errors.should contain "Forbidden"
    # ^^ doesn't work because ^^ error handlers don't get applied right away.
  end
end
