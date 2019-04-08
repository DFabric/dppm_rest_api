describe DppmRestApi::Route do
  it "works as expected" do
    test_rte = DppmRestApi::Route.new(
      DppmRestApi::Access::Create, {"namespace" => "test-namespace"})
    test_rte.match?(HTTP::Params.new({"namespace" => ["test-namespace"]})).should be_true
    test_rte.match?(HTTP::Params.new({"namespace" => ["not the right namespace"]})).should be_false
  end
end
