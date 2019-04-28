require "./utils"
require "./config"
require "./dppm_rest_api/actions"

module DppmRestApi
  VERSION  = "0.2.0"
  TEST_DIR = "#{File.dirname(__DIR__)}/spec/test-data"
  class_property default_namespace : String { config.default_namespace }

  class_property config : Config do
    Config.new ::File.join TEST_DIR, "config"
  end

  def self.run(port : Int32, host : String)
    # Kemal doesn't like IPV6 brackets
    Kemal.config.host_binding = host.lchop('[').rchop(']')
    Kemal.run port: port
  end
end
