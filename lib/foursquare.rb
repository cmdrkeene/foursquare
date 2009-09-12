module Foursquare#:nodoc:
  include HTTParty
  base_uri "http://api.playfoursquare.com/v1"
  format :json
    
  # API returned 401 Unauthorized
  class UnauthorizedException < Exception
  end
  
  # API could not find record
  class RecordNotFound < Exception
  end

  # Returns a list of currently active cities.
  # http://api.playfoursquare.com/v1/cities
  def self.cities
    get("/cities.json", :query => nil)["cities"]
  end

  # Test if API is up and available
  # http://api.playfoursquare.com/v1/test
  def self.available?
    response = get("/test.json", :query => nil)
    (!response.nil? && response["response"] == "ok") ? true : false
  end
end