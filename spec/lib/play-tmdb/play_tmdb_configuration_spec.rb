require "rubygems"
require "rspec"
require "play-tmdb/base"
require "play-tmdb/configuration"
require "support/mock_requests"

describe "Play::Tmdb::Configuration" do
  include MockRequests

  before :each do
    mock_configuration
    @remote_configuration=Play::Tmdb::Configuration.remote
  end

  describe "Images" do
    it "should have base_url" do
      Play::Tmdb::Configuration::Images.base_url.should == @remote_configuration.images.base_url
    end

    it "should have poster_sizes" do
      Play::Tmdb::Configuration::Images.poster_sizes.should == @remote_configuration.images.poster_sizes
    end

    it "should have backdrop_sizes" do
      Play::Tmdb::Configuration::Images.backdrop_sizes.should == @remote_configuration.images.backdrop_sizes
    end

    it "should have profile_sizes" do
      Play::Tmdb::Configuration::Images.profile_sizes.should == @remote_configuration.images.profile_sizes
    end
  end
end
