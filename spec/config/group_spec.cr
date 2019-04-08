require "../spec_helper"

describe DppmRestApi::Group do
  describe "fixture data" do
    it "was parsed correctly" do
      admin_group = DppmRestApi.config.file.groups.find { |group| group.name == "admin" }.not_nil!
      admin_group.id.should eq 0
      admin_group
        .permissions
        .find { |p| p.glob == "/**" }.not_nil!
        .route
        .access
        .should eq DppmRestApi::Access::All
      normal_group = DppmRestApi.config.file.groups.find { |group| group.name == "Normal user" }.not_nil!
      normal_group.id.should eq 850
      normal_group.permissions.size.should eq 3
      default_namespace = DppmRestApi.config.file.groups.find { |group| group.name == "Default namespace" }.not_nil!
    end
  end
  describe "#can_access?" do
    it "allows access to a specific glob" do
      normal_group = DppmRestApi.config.file.groups.find { |group| group.name == "Normal user" }.not_nil!
      normal_group.can_access?(
        "/app/nextcloud",
        HTTP::Params.new,
        DppmRestApi::Access::Read).should be_true
    end
    it "denies access to a specific glob" do
      normal_group = DppmRestApi.config.file.groups.find { |group| group.name == "Normal user" }.not_nil!
      normal_group.can_access?(
        "/app/etherpad/config/admin_password",
        HTTP::Params.new,
        DppmRestApi::Access::Read).should be_false
    end
    it "allows access to a specific namespace (query parameter)" do
      def_ns_group = DppmRestApi.config.file.groups.find { |group| group.id == 851 }.not_nil!
      def_ns_group.can_access?(
        "/app/transmission",
        HTTP::Params.new({"namespace" => ["default_namspace"]}),
        DppmRestApi::Access::Read).should be_true
    end
    it "denies access to an absent or incorrect namespace" do
      def_ns_group = DppmRestApi.config.file.groups.find { |group| group.id == 851 }.not_nil!
      def_ns_group.can_access?(
        "/app/transmission",
        HTTP::Params.new({"namespace" => ["incorrect_namespace"]}),
        DppmRestApi::Access::Read).should be_false
      def_ns_group.can_access?(
        "/app/transmission",
        HTTP::Params.new,
        DppmRestApi::Access::Read).should be_false
    end
  end
end
