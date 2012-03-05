module Play
  module Tmdb
    class Movie
      def self.new(raw_data, fetch_all_data = false, language = nil)
        # expand the result by calling Movie.getInfo unless :expand_results is false or the data is already complete
        # (as determined by checking for the trailer property in the raw data)

        if (fetch_all_data)
          expanded_data = info(id: raw_data["id"], language: language)
          raise ArgumentError, "Unable to fetch expanded info for Movie ID: '#{raw_data["id"]}'" if expanded_data.nil?
          raw_data = expanded_data.marshal_dump
        end

        DeepOpenStruct.load(raw_data)
      end

      def self.search(params={})
        if !params[:query] or params[:query].empty?
          raise ArgumentError.new("query param is required")
        end

        body = Play::Tmdb::Base.api_call("search/movie", params)

        results = body.results.map do |r|
          new(r, true)
        end

        results
      end

      def self.info(params={id: ""})
        raise ArgumentError.new("valid id is required") if params[:id].to_s.empty?


        time = Benchmark.realtime do
          @info = Play::Tmdb::Base.api_call("movie/#{params[:id]}", params)
        end

        puts "----------------------------------------------------------------------------"
        puts "Movie.info: #{time} seconds"
        puts "----------------------------------------------------------------------------"

        time = Benchmark.realtime do
          @images = images(params)
          @info.posters = @images.posters
          @info.backdrops = @images.backdrops
        end

        puts "----------------------------------------------------------------------------"
        puts "Movie.images: #{time} seconds"
        puts "----------------------------------------------------------------------------"

        @info
      end

      def self.images(params={id: ""})
        raise ArgumentError.new("valid id is required") if params[:id].to_s.empty?

        body = Play::Tmdb::Base.api_call("movie/#{params[:id]}/images", params.keep_if { |k, v| k!=:id })
        body.posters = body.posters.collect { |poster| OpenStruct.new(poster) }
        body.backdrops = body.backdrops.collect { |backdrop| OpenStruct.new(backdrop) }
        body
      end
    end
  end
end