enum DppmRestApi::Access
  def self.publicised_parse_strings?(*args, **opts)
    parse_strings? *args, **opts
  end
end

describe DppmRestApi::Access do
  describe "the values" do
    it "has shortcuts" do
      DppmRestApi::Access::All.should eq DppmRestApi::Access::Create |
                                         DppmRestApi::Access::Read |
                                         DppmRestApi::Access::Update |
                                         DppmRestApi::Access::Delete
      DppmRestApi::Access::None.value.should eq 0
      DppmRestApi::Access::All.value.should eq 15
      DppmRestApi::Access.super_user.should eq DppmRestApi::Access::All
      DppmRestApi::Access.deny.should eq DppmRestApi::Access::None
    end
    it "parses an array of strings into a value" do
      DppmRestApi::Access.publicised_parse_strings?(["Create", "Read"])
        .should eq DppmRestApi::Access::Create |
                   DppmRestApi::Access::Read
      DppmRestApi::Access
        .publicised_parse_strings?(["Create", "Read", "Update", "Delete"])
        .should eq DppmRestApi::Access.super_user
    end
    it "parses a pipe-separated (|) string" do
      txt = "Create | Read | Update | Delete".to_json
      DppmRestApi::Access.new(JSON::PullParser.new input: txt).should eq DppmRestApi::Access::All
    end
    it "can be represented as an integer" do
      DppmRestApi::Access::None.value.should eq 0
      DppmRestApi::Access::All.value.should eq 15
      DppmRestApi::Access::Create.value.should eq 1
      DppmRestApi::Access::Read.value.should eq 2
      (DppmRestApi::Access::Create | DppmRestApi::Access::Read).value.should eq (1 | 2)
    end
  end
end
