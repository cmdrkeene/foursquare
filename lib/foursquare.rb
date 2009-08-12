require 'httparty'

class Foursquare
  class VenueNotFoundError < StandardError;end
  
  include HTTParty
  base_uri "http://api.playfoursquare.com/v1"
  format :json
  
  def initialize(username, password)
    @auth = {:username => username, :password => password}
  end
  
  def check_in(venue_id)
    raise ArgumentError, "you must pass a venue_id" unless venue_id
    response = self.class.post("/checkin.json", {:query => {:vid => venue_id}, :basic_auth => @auth})
    raise VenueNotFoundError if response.keys.include?("addvenueprompt")
    response["checkin"]
  end
end