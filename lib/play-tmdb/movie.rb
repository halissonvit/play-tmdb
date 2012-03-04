module Play
  module Tmdb
    class Movie
      def self.new(raw_data, fetch_all_data = false, language = nil)
        # expand the result by calling Movie.getInfo unless :expand_results is false or the data is already complete
        # (as determined by checking for the trailer property in the raw data)

        if (fetch_all_data)
          #Call getInfo
        end

        DeepOpenStruct.load(raw_data)
      end

      def self.search(params={})
        if !params[:query] or params[:query].empty?
          raise ArgumentError.new("query param is required")
        end

        body = Play::Tmdb::Base.api_call("search/movie", params)

        results = body.results.map do |r|
          new(r)
        end

        results
      end
    end
  end
end