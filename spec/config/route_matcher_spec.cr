describe DppmRestApi::Route do
  it "works as expected" do
    test_rte = DppmRestApi::Route.new DppmRestApi::Route::HTTPVerb::GET, "/api/app/**", DppmRestApi::Access::Create
    test_rte.match?(DppmRestApi::Route::HTTPVerb::GET, "/api/app/some/path").should be_true
    test_rte.match?(DppmRestApi::Route::HTTPVerb::POST, "/api/app/some/path").should be_false
    test_rte.match?(DppmRestApi::Route::HTTPVerb::GET, "/a/different/path").should be_false
  end
end
