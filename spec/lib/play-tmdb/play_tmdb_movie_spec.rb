require "spec_helper"

describe "Play::Tmdb::Movie" do
  def star_wars_info_response
    File.open(File.join(File.dirname(__FILE__), "../..", "fixtures", "star_wars_info.txt"))
  end

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
      response_with_results = File.open(File.join(File.dirname(__FILE__), "../..", "fixtures", "frankenweenie.txt"))
      stub_request(:get, Regexp.new(Play::Tmdb::Base.base_url + ".*" + "frankenweenie")).to_return(File.open(File.join(response_with_results)))
      stub_request(:get, Regexp.new(Play::Tmdb::Base.base_url + "movie/" + "\d*")).to_return(File.open(File.join(star_wars_info_response)))

      Play::Tmdb::Movie.search(:query => "frankenweenie").size.should == 2
    end
  end

  context "info" do
    before :each do
      regex_url = Regexp.new(Play::Tmdb::Base.base_url + "movie/" + "11" + ".*")
      @request = stub_request(:get, regex_url)
      @request.to_return(File.open(File.join(star_wars_info_response)))
    end

    it "should receive nonblank id" do
      expect {
        Play::Tmdb::Movie.info(id: "11")
      }.should_not raise_error(ArgumentError, "valid id is required")

      expect {
        Play::Tmdb::Movie.info(id: "")
      }.should raise_error(ArgumentError, "valid id is required")
    end

    it "should hit info url" do
      Play::Tmdb::Movie.info(id: "11")
      @request.should have_been_made.times(1)
    end

    context "return should contains" do
      before :each do
        @movie = Play::Tmdb::Movie.info(id: "11")
      end

      it "adult" do
        @movie.should respond_to :adult
      end

      it "backdrop_path" do
        @movie.should respond_to :backdrop_path
      end

      it "belongs_to_collection" do
        @movie.should respond_to :belongs_to_collection
      end

      it "budget" do
        @movie.should respond_to :budget
      end

      it "genres" do
        @movie.should respond_to :genres
      end

      it "homepage" do
        @movie.should respond_to :homepage
      end

      it "id" do
        @movie.should respond_to :id
      end

      it "imdb_id" do
        @movie.should respond_to :imdb_id
      end

      it "overview" do
        @movie.should respond_to :overview
      end

      it "popularity" do
        @movie.should respond_to :popularity
      end

      it "poster_path" do
        @movie.should respond_to :poster_path
      end

      it "production_companies" do
        @movie.should respond_to :production_companies
      end

      it "production_countries" do
        @movie.should respond_to :production_countries
      end

      it "release_date" do
        @movie.should respond_to :release_date
      end

      it "revenue" do
        @movie.should respond_to :revenue
      end

      it "runtime" do
        @movie.should respond_to :runtime
      end

      it "spoken_languages" do
        @movie.should respond_to :spoken_languages
      end

      it "tagline" do
        @movie.should respond_to :tagline
      end

      it "title" do
        @movie.should respond_to :title
      end

      it "vote_average" do
        @movie.should respond_to :vote_average
      end

      it "vote_count" do
        @movie.should respond_to :vote_count
      end
    end
  end
end
