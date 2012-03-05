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
      mock_search_movies_no_results
      Play::Tmdb::Movie.search(:query => "item_not_found").should == []
    end

    it "that returns results should create array of OpenStructs with data movie" do
      mock_search_movies
      mock_info_movie
      mock_images_movie

      Play::Tmdb::Movie.search(:query => "frankenweenie").size.should == 2
    end
  end

  context "info" do
    before :each do
      @request = mock_info_movie
      @image_request = mock_images_movie_no_results
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

    it "should hit images url" do
      Play::Tmdb::Movie.info(id: "11")
      @image_request.should have_been_made.times(1)
    end

    context "return should contains" do
      before :each do
        @poster = Play::Tmdb::Movie.info(id: "11")
      end

      it "adult" do
        @poster.should respond_to :adult
      end

      it "backdrop_path" do
        @poster.should respond_to :backdrop_path
      end

      it "belongs_to_collection" do
        @poster.should respond_to :belongs_to_collection
      end

      it "budget" do
        @poster.should respond_to :budget
      end

      it "genres" do
        @poster.should respond_to :genres
      end

      it "homepage" do
        @poster.should respond_to :homepage
      end

      it "id" do
        @poster.should respond_to :id
      end

      it "imdb_id" do
        @poster.should respond_to :imdb_id
      end

      it "overview" do
        @poster.should respond_to :overview
      end

      it "popularity" do
        @poster.should respond_to :popularity
      end

      it "poster_path" do
        @poster.should respond_to :poster_path
      end

      it "production_companies" do
        @poster.should respond_to :production_companies
      end

      it "production_countries" do
        @poster.should respond_to :production_countries
      end

      it "release_date" do
        @poster.should respond_to :release_date
      end

      it "revenue" do
        @poster.should respond_to :revenue
      end

      it "runtime" do
        @poster.should respond_to :runtime
      end

      it "spoken_languages" do
        @poster.should respond_to :spoken_languages
      end

      it "tagline" do
        @poster.should respond_to :tagline
      end

      it "title" do
        @poster.should respond_to :title
      end

      it "vote_average" do
        @poster.should respond_to :vote_average
      end

      it "vote_count" do
        @poster.should respond_to :vote_count
      end
    end
  end

  context "images" do
    before :each do
      @request = mock_images_movie
    end

    it "should receive nonblank id" do
      expect {
        Play::Tmdb::Movie.images(id: "11")
      }.should_not raise_error(ArgumentError, "valid id is required")

      expect {
        Play::Tmdb::Movie.images(id: "")
      }.should raise_error(ArgumentError, "valid id is required")
    end

    it "should hit images url" do
      Play::Tmdb::Movie.images(id: "11")
      @request.should have_been_made.times(1)
    end

    context "should create empty array for results whithout" do
      before :each do
        mock_images_movie_no_results
      end

      it "backdrops" do
        Play::Tmdb::Movie.images(:id => "20").backdrops.should == []
      end

      it "posters" do
        Play::Tmdb::Movie.images(:id => "20").posters.should == []
      end
    end

    context "should contains" do
      context "backdrops and posters" do
        before :each do
          @poster = Play::Tmdb::Movie.images(id: "11").posters.first
          @backdrop = Play::Tmdb::Movie.images(id: "11").backdrops.first
        end

        it "aspect_ratio" do
          @poster.should respond_to :aspect_ratio
          @backdrop.should respond_to :aspect_ratio
        end

        it "file_path" do
          @poster.should respond_to :file_path
          @backdrop.should respond_to :file_path
        end

        it "width" do
          @poster.should respond_to :width
          @backdrop.should respond_to :width
        end

        it "height" do
          @poster.should respond_to :width
          @backdrop.should respond_to :width
        end

        it "iso_639_1" do
          @poster.should respond_to :iso_639_1
          @backdrop.should respond_to :iso_639_1
        end

        it "vote_average" do
          @poster.should respond_to :vote_average
          @backdrop.should respond_to :vote_average
        end

        it "vote_count" do
          @poster.should respond_to :vote_count
          @backdrop.should respond_to :vote_count
        end
      end
    end
  end
end
