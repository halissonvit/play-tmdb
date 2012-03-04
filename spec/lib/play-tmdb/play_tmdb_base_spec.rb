require "spec_helper"

describe "Play::Tmdb::Base" do
  def clapper_com_response
    File.open(File.join(File.dirname(__FILE__), "../..", "fixtures", "example_com.txt"))
  end

  def incorrect_api_url_response
    File.open(File.join(File.dirname(__FILE__), "../..", "fixtures", "incorrect_api_url.txt"))
  end

  def empty_result_response
    File.open(File.join(File.dirname(__FILE__), "../..", "fixtures", "blank_result.txt"))
  end

  before :each do
    Play::Tmdb::Base.options=Play::Tmdb::Base.default_options
  end

  it "should have options" do
    Play::Tmdb::Base.should respond_to(:options)
  end

  it "should default language to 'en'" do
    Play::Tmdb::Base.options[:language].should == "en"
  end

  it "should allow set language" do
    Play::Tmdb::Base.language = "pt"
    Play::Tmdb::Base.options[:language].should == "pt"
  end

  it "should allow set api_key" do
    Play::Tmdb::Base.api_key = "ood3pok0329id"
    Play::Tmdb::Base.options[:api_key].should == "ood3pok0329id"
  end

  it "should default api_key to ''" do
    Play::Tmdb::Base.options[:api_key].should == ""
  end

  it "should have base url" do
    Play::Tmdb::Base.base_url.should == "http://api.themoviedb.org/3/"
  end

  describe "get url" do
    before :each do
      stub_request(:get, "http://www.clapper.com.br/").to_return(File.open(File.join(clapper_com_response)))

      stub_request(:get, "http://www.noasdoansdonaosdnoad.com.br/").to_return(File.open(File.join(incorrect_api_url_response)))
    end

    it "that is valid returns a response object with code 200" do
      test_response = Play::Tmdb::Base.get_url("http://www.clapper.com.br/")
      test_response.code.to_i.should == 200
    end

    it "that is nonexistent returns a response object with code 404" do
      test_response = Play::Tmdb::Base.get_url("http://www.noasdoansdonaosdnoad.com.br/")
      test_response.code.to_i.should == 404
    end
  end

  describe "api call" do
    before :each do
      @api_key="tt"
      @language="en"
      @params = {query: "filme_bom"}
      @method = "search/movie"
      Play::Tmdb::Base.api_key=@api_key
      Play::Tmdb::Base.language=@language
    end

    it "raises ArgumentError if no method is passed" do
      expect {
        Play::Tmdb::Base.api_call("")
      }.should raise_error(ArgumentError, "api method is required")
    end

    it "mount query with params" do
      url = "#{Play::Tmdb::Base.base_url}#{@method}?api_key=#{@api_key}&language=#{@language}&query=#{@params[:query]}"
      request = stub_request(:get, url).to_return(empty_result_response)
      Play::Tmdb::Base.api_call(@method, @params)
      request.should have_been_made.times(1)
    end
  end

  context "@@options" do
    it "should inject setter" do
      Play::Tmdb::Base.should respond_to(:language=)
      Play::Tmdb::Base.should respond_to(:api_key=)
    end

    it "should inject getter" do
      Play::Tmdb::Base.should respond_to(:language)
      Play::Tmdb::Base.should respond_to(:api_key)
    end
  end
end
