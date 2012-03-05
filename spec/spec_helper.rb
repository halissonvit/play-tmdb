require 'play-tmdb'
require 'webmock/rspec'
require 'support/mock_requests'

if ENV["test_api"] and ENV["tmdb_api_key"]
  include WebMock::API
  Play::Tmdb::Base.api_key = ENV["tmdb_api_key"]
end

include MockRequests