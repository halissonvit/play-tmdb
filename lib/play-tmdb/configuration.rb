module Play
  module Tmdb
    module Configuration
      class Images
        @@base_url = "http://cf2.imgobject.com/t/p/"
        @@poster_sizes = ["w92", "w154", "w185", "w342", "w500", "original"]
        @@backdrop_sizes = ["w300", "w780", "w1280", "original"]
        @@profile_sizes = ["w45", "w185", "h632", "original"]

        def self.base_url
          @@base_url
        end

        def self.poster_sizes
          @@poster_sizes
        end

        def self.backdrop_sizes
          @@backdrop_sizes
        end

        def self.profile_sizes
          @@profile_sizes
        end
      end

      def self.remote
        configuration = Play::Tmdb::Base.api_call("configuration", {})
        configuration.images = OpenStruct.new(configuration.images)
        configuration
      end
    end
  end
end