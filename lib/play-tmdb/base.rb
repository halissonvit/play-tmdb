require 'net/http'
require 'uri'
require 'cgi'
require 'json'
require 'deepopenstruct'
require "addressable/uri"
require "yajl"

module Play
  module Tmdb
    class Base
      def self.default_options
        {
            api_key: "",
            language: "en"
        }
      end

      @@options = Tmdb::Base.default_options
      @@base_url = "http://api.themoviedb.org/3/"

      # Injecting accessors to each @@options key

      class_eval "default_options.each do |k,v|
        class_eval\"
          def self.\#{k}=(\#{k})
            @@options[:\#{k}]=\#{k}
          end

          def self.\#{k}
            @@options[:\#{k}]
          end
        \"
      end"

      def self.options=(options)
        @@options=options
      end

      def self.options
        @@options
      end

      def self.base_url
        @@base_url
      end

      # Get a URL and return a response object, follow upto 'limit' re-directs on the way
      def self.get_url(uri_str, limit = 10)
        return false if limit == 0
        begin
          response = Net::HTTP.get_response(URI.parse(uri_str))
        rescue SocketError, Errno::ENETDOWN
          response = Net::HTTPBadRequest.new('404', 404, "Not Found")
          return response
        end
        case response
          when Net::HTTPSuccess then
            response
          when Net::HTTPRedirection then
            get_url(response['location'], limit - 1)
          else
            Net::HTTPBadRequest.new('404', 404, "Not Found")
        end
      end

      def self.api_call(method, params = {})
        raise ArgumentError.new("api method is required") if method.empty?

        url = build_api_url(method, params)

        time = Benchmark.realtime do
          @response = Play::Tmdb::Base.get_url(url).body
        end
        puts "request: #{time} seconds"

        parser = Yajl::Parser.new
        time = Benchmark.realtime do
          @body = parser.parse(@response)
        end
        puts "build_json: #{time} seconds"
        time = Benchmark.realtime do
          @object = OpenStruct.new body
        end
        puts "build_object: #{time} seconds"

        @object
      end

      private
      def self.build_api_url(method, params)
        base_url + method + "?" + build_params_of_url(params)
      end

      def self.build_params_of_url(params)
        options.merge(params).collect { |key, value| "#{key}=#{value}" }.join("&")
      end
    end
  end
end
