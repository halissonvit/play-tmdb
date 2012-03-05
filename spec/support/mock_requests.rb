module MockRequests
  def expected_fixture(file_name)
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "#{file_name}"))
  end

  def mock_site_request
    request = stub_request(:get, "http://www.clapper.com.br/")
    request.to_return(expected_fixture("example_com.txt"))
    request
  end

  def mock_invalid_site_request
    request = stub_request(:get, "http://www.noasdoansdonaosdnoad.com.br/")
    request.to_return(expected_fixture("incorrect_api_url.txt"))
    request
  end

  def mock_search_movies_no_results
    request = stub_request(:get, Regexp.new(Play::Tmdb::Base.base_url + "search/movie\\?.*" + "query=item_not_found"))
    request.to_return(expected_fixture("blank_result.txt"))
    request
  end

  def mock_search_movies
    request = stub_request(:get, Regexp.new(Play::Tmdb::Base.base_url + "search/movie\\?.*" + "query=frankenweenie"))
    request.to_return(expected_fixture("frankenweenie.txt"))
    request
  end

  def mock_info_movie
    request = stub_request(:get, Regexp.new(Play::Tmdb::Base.base_url + "movie/" + "\\d*\\?api_key=.*"))
    request.to_return(expected_fixture("star_wars_info.txt"))
    request
  end

  def mock_images_movie
    request = stub_request(:get, Regexp.new(Play::Tmdb::Base.base_url + "movie/\\d*/images\\?api_key=.*"))
    request.to_return(expected_fixture("images_result.txt"))
    request
  end

  def mock_images_movie_no_results
    request = stub_request(:get, Regexp.new(Play::Tmdb::Base.base_url + "movie/\\d*/images\\?api_key=.*"))
    request.to_return(expected_fixture("images_blank_result.txt"))
    request
  end

  def mock_configuration
    request = stub_request(:get, Regexp.new(Play::Tmdb::Base.base_url + "configuration\\?api_key=.*"))
    request.to_return(expected_fixture("configuration.txt"))
    request
  end
end