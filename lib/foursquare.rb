require 'httparty'

class Foursquare
  class VenueNotFoundError < StandardError;end
  
  include HTTParty
  base_uri "http://api.playfoursquare.com/v1"
  format :json
  
  def initialize(username = nil, password = nil)
    @auth = {:username => username, :password => password}
  end
  
  # Allows you to check-in to a place.
  # :vid      => (optional, not necessary if you are 'shouting' or have a venue name). ID of the venue where you want to check-in.
  # :venue    => (optional, not necessary if you are 'shouting' or have a vid) if you don't have a venue ID, pass the venue name as a string using this parameter. foursquare will attempt to match it on the server-side
  # :shout    => (optional) a message about your check-in
  # :private  => (optional, defaults to the user's setting). true means "don't show your friends". false means "show everyone"
  # :twitter  => (optional, defaults to the user's setting). false means "send to twitter". false means "don't send to twitter"
  # :geolat   => (optional, but recommended)
  # :geolong  => (optional, but recommended)
  def checkin(options = {})
    unless options[:private].nil?
      options[:private] = 1 if options[:private] == true
      options[:private] = 0 if options[:private] == false
    end
    unless options[:twitter].nil?
      options[:twitter] = 1 if options[:twitter] == true
      options[:twitter] = 0 if options[:twitter] == false
    end
    response = self.class.post("/checkin.json", :query => options, :basic_auth => @auth)
    raise VenueNotFoundError if response.keys.include?("addvenueprompt")
    response["checkin"]
  end
  
  def cities
    self.class.cities
  end
  
  # Class methods
  def self.cities
    get("/cities.json")["cities"]
  end
end