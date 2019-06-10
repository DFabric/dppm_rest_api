require "./spec_helper"

describe "Actions.throw_error" do
  it "expands as expected" do
    backing_io, context = new_test_context
    app_name = "test.app.name"
    DppmRestApi::Actions.throw_error context, "no config with app named '#{app_name}' found", status_code: 404
    context.response.status_code.should eq 404
    context.@stacks["error"].should contain "no config with app named 'test.app.name' found"
  end
end
