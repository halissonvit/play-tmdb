require "spec_helper"

describe "Play::Tmdb::Movie" do
  context "search" do
    it "raises ArgumentError if no query param is passed" do
      expect {
        Play::Tmdb::Movie.search()
      }.should raise_error(ArgumentError, "query param is required")
    end

    it "raises ArgumentError if no query param is blank" do
      expect {
        Play::Tmdb::Movie.search(query: "")
      }.should raise_error(ArgumentError, "query param is required")
    end

    it "that returns no results should create empty array" do
      blank_result = File.open(File.join(File.dirname(__FILE__), "../..", "fixtures", "blank_result.txt"))
      stub_request(:get, Regexp.new(Play::Tmdb::Base.base_url + ".*" + "item_not_found")).to_return(File.open(File.join(blank_result)))

      Play::Tmdb::Movie.search(:query => "item_not_found").should == []
    end

    it "that returns results should create array of OpenStructs with data movie" do
      blank_result = File.open(File.join(File.dirname(__FILE__), "../..", "fixtures", "frankenweenie.txt"))
      stub_request(:get, Regexp.new(Play::Tmdb::Base.base_url + ".*" + "frankenweenie")).to_return(File.open(File.join(blank_result)))

      Play::Tmdb::Movie.search(:query => "frankenweenie").size.should == 2
    end
  end
end
