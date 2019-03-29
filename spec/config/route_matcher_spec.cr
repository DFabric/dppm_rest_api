describe DppmRestApi::Route do
  it "works as expected (integration test with globs)" do
    test_rte = DppmRestApi::Route.new DppmRestApi::Route::HTTPVerb::GET, "/api/app/**"
    test_rte.match?(DppmRestApi::Route::HTTPVerb::GET, "/api/app/some/path").should be_true
    test_rte.match?(DppmRestApi::Route::HTTPVerb::POST, "/api/app/some/path").should be_false
    test_rte.match?(DppmRestApi::Route::HTTPVerb::GET, "/a/different/path").should be_false
  end
end

describe DppmRestApi::Route::Glob do
  test_glob = DppmRestApi::Route::Glob.new "/some/*/path/{to,a,resource}/"
  it "reads in the values right" do
    test_glob.parts.size.should eq 4
    test_glob.parts[0].type.should eq DppmRestApi::Route::Glob::Part::Type::Specific
    test_glob.parts[0].@specific_value.should eq "some"
    test_glob.parts[1].type.should eq DppmRestApi::Route::Glob::Part::Type::Any
    test_glob.parts[3].type.should eq DppmRestApi::Route::Glob::Part::Type::Many
    test_glob.parts[3].@many_values.should eq Set["to", "a", "resource"]
  end
  describe "#match?" do
    it "matches an expected match" do
      test_glob.match?("/some/arbitrary/path/to").should be_true
    end
    it "does not match an unexpected match" do
      test_glob.match?("/some/path/to").should be_false
      test_glob.match?("/some/x/path").should be_false
      test_glob.match?("/a/different/path/entirely").should be_false
      test_glob.match?("/some/x/path/to/too-far").should be_false
    end
  end
end

describe DppmRestApi::Route::Glob::Part do
  context "a specifc match" do
    test_part = DppmRestApi::Route::Glob::Part.new("some-text")
    it "matches to the correct value" do
      test_part.matches?("some-text").should eq DppmRestApi::Route::Glob::Part::MatchStatus::Matches
    end
    it "does not match an incorrect value" do
      test_part.matches?("any other string").should eq DppmRestApi::Route::Glob::Part::MatchStatus::DoesNotMatch
    end
    it "has the right type" do
      test_part.should be_a DppmRestApi::Route::Glob::MatchSpecific
    end
  end
  context "a multiple-options match" do
    test_part = DppmRestApi::Route::Glob::Part.new("{a,few,matches}")
    it "matches to the correct value" do
      test_part.matches?("a").should eq DppmRestApi::Route::Glob::Part::MatchStatus::Matches
      test_part.matches?("few").should eq DppmRestApi::Route::Glob::Part::MatchStatus::Matches
      test_part.matches?("matches").should eq DppmRestApi::Route::Glob::Part::MatchStatus::Matches
    end
    it "does not match an incorrect value" do
      test_part.matches?("any other string").should eq DppmRestApi::Route::Glob::Part::MatchStatus::DoesNotMatch
    end
    it "has the right type" do
      test_part.should be_a DppmRestApi::Route::Glob::MatchMany
    end
  end
  context "a wildcard" do
    test_part = DppmRestApi::Route::Glob::Part.new("*")
    it "matches to any string" do
      test_part.matches?("any").should eq DppmRestApi::Route::Glob::Part::MatchStatus::Matches
      test_part.matches?("string").should eq DppmRestApi::Route::Glob::Part::MatchStatus::Matches
    end
    it "has the right type" do
      test_part.should be_a DppmRestApi::Route::Glob::MatchAny
    end
  end
  context "a recursive wildcard." do
    test_part = DppmRestApi::Route::Glob::Part.new("**")
    it "matches to any string" do
      test_part.matches?("any").should eq DppmRestApi::Route::Glob::Part::MatchStatus::RecursivelyMatches
      test_part.matches?("string").should eq DppmRestApi::Route::Glob::Part::MatchStatus::RecursivelyMatches
    end
    it "has the right type" do
      test_part.should be_a DppmRestApi::Route::Glob::MatchRecursiveAny
    end
  end
end
