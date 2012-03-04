module Play
  module Tmdb
    class Base
      require 'net/http'
      require 'uri'
      require 'cgi'
      require 'json'
      require 'deepopenstruct'
      require "addressable/uri"

      def self.default_options
        {api_key: "",
         language: "en"}
      end

      @@options = Tmdb::Base.default_options
      @@base_url = "http://api.themoviedb.org/3/"

      def self.options=(options)
        @@options=options
      end

      def self.options
        @@options
      end

      def self.base_url
        @@base_url
      end

      def self.api_key
        @@options[:api_key]
      end

      def self.api_key=(api_key)
        @@options[:api_key]=api_key
      end

      def self.language
        @@options[:language]
      end

      def self.language=(language)
        @@options[:language]=language
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
    end
  end
end
