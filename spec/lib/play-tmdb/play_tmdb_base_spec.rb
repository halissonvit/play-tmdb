require "spec_helper"

describe "Play::Tmdb" do
  require 'webmock/test_unit'
  include WebMock::API

  before :each do
    Play::Tmdb.options=Play::Tmdb.default_options
  end

  it "should have options" do
    Play::Tmdb.should respond_to(:options)
  end

  it "should default language to 'en'" do
    Play::Tmdb.options[:language].should == "en"
  end

  it "should allow set language" do
    Play::Tmdb.language = "pt"
    Play::Tmdb.options[:language].should == "pt"
  end

  it "should allow set api_key" do
    Play::Tmdb.api_key = "ood3pok0329id"
    Play::Tmdb.options[:api_key].should == "ood3pok0329id"
  end

  it "should default api_key to ''" do
    Play::Tmdb.options[:api_key].should == ""
  end

  it "should have base url" do
    Play::Tmdb.base_url.should == "http://api.themoviedb.org/3/"
  end

  describe "get url" do
    before :each do
      clapper_com = File.open(File.join(File.dirname(__FILE__), "../..", "fixtures", "example_com.txt"))
      stub_request(:get, "http://www.clapper.com.br/").to_return(File.open(File.join(clapper_com)))

      incorrect_api_url = File.open(File.join(File.dirname(__FILE__), "../..", "fixtures", "incorrect_api_url.txt"))
      stub_request(:get, "http://www.noasdoansdonaosdnoad.com.br/").to_return(File.open(File.join(incorrect_api_url)))
    end

    it "that is valid returns a response object with code 200" do
      test_response = Play::Tmdb.get_url("http://www.clapper.com.br/")
      test_response.code.to_i.should == 200
    end

    it "that is nonexistent returns a response object with code 404" do
      test_response = Play::Tmdb.get_url("http://www.noasdoansdonaosdnoad.com.br/")
      test_response.code.to_i.should == 404
    end
  end
end
