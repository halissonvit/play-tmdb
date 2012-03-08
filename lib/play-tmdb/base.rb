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
      class << self
        def default_options
          {api_key: "", language: "en"}
        end

        @@options = Tmdb::Base.default_options
        @@base_url = "http://api.themoviedb.org/3/"

        def options=(options)
          @@options=options
        end

        def options
          @@options
        end

        def base_url
          @@base_url
        end

        # Get a URL and return a response object, follow upto 'limit' re-directs on the way
        def get_url(uri_str, limit = 10)
          Curl::Easy.perform(uri_str)
        end

        def api_call(method, params = {})
          raise ArgumentError.new("api method is required") if method.empty?

          url = build_api_url(method, params)
          response = Play::Tmdb::Base.get_url(url)
          body = response.body_str

          json_object = Yajl::Parser.new.parse(body)

          OpenStruct.new json_object
        end

        private
        def build_api_url(method, params)
          base_url + method + "?" + build_params_of_url(params)
        end

        def build_params_of_url(params)
          options.merge(params).collect { |key, value| "#{key}=#{value}" }.join("&")
        end

        def method_missing(name_method, *args)
          if default_options.key? :name_method
            options[:name_method]
          elsif default_options.key? "#{name_method.to_s.gsub("=", "")}".to_sym
            options["#{name_method.to_s.gsub("=", "")}".to_sym]=args.first
          else
            super
          end
        end
      end
    end
  end
end
