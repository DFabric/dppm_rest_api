describe DppmRestApi::Config::File do
  describe "#user" do
    it "finds a user by its name" do
      DppmRestApi.config.file.user(named: "Test User").should_not be_nil
    end
  end
end
