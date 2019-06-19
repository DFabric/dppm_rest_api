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

struct ErrorResponse
  property errors : Array(String)
  include JSON::Serializable
end

Kemal.config.env = "test"

already_running = false

def run_server
  DppmRestApi.run Socket::IPAddress::LOOPBACK, DPPM::Prefix.default_dppm_config.port, __DIR__
  already_running = true
end

# Set up the mock permissions.json

# the location
PERMISSION_FILE = Path[__DIR__, "permissions.json"]

Spec.before_each do
  DppmRestApi.permissions_config = Fixtures.permissions_config
  DppmRestApi.permissions_config.write_to PERMISSION_FILE
  run_server unless already_running
end
# Clean up after ourselves
Spec.after_each do
  File.delete PERMISSION_FILE if File.exists? PERMISSION_FILE
end
