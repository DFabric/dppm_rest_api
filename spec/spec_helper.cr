require "spec"
require "spec-kemal"
require "../src/dppm_rest_api"
require "./fixtures"

CRLF = "\r\n"

def new_test_context(verb = "GET", path = "/api/test")
  backing_io = IO::Memory.new
  request = HTTP::Request.new verb, path
  response = HTTP::Server::Response.new backing_io
  {backing_io, HTTP::Server::Context.new(request, response)}
end

struct ErrorData
  include JSON::Serializable
  property type : String
  property message : String
  property status_code : Int32?
end

struct ErrorResponse
  include JSON::Serializable
  property errors : Array(ErrorData)
end

def assert_unauthorized(response : HTTP::Client::Response)
  response.status_code.should eq 401
  ErrorResponse.from_json(response.body)
    .errors
    .find { |err| err.message == "Unauthorized" }
    .should_not be_nil
end

Kemal.config.env = "test"

# Set up the mock permissions.json

# the location
PERMISSION_FILE = Path[__DIR__, "permissions.json"]

# Set all configs to the expected values.
def reset_config
  DppmRestApi.permissions_config = Fixtures.permissions_config
  DppmRestApi.permissions_config.write_to PERMISSION_FILE
end

reset_config
# Run the server
DppmRestApi.run Socket::IPAddress::LOOPBACK, DPPM::Prefix.default_dppm_config.port, __DIR__
# Set all configs back to the expected values, in case they changed
Spec.before_each { reset_config }
# Clean up after ourselves
Spec.after_each { File.delete PERMISSION_FILE if File.exists? PERMISSION_FILE }
