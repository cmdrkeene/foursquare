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
  #
  # Options
  #   :vid      => (optional, not necessary if you are 'shouting' or have a
  #                venue name). ID of the venue where you want to check-in.
  #   :venue    => (optional, not necessary if you are 'shouting' or have a
  #                vid) if you don't have a venue ID, pass the venue name as
  #                a string using this parameter. foursquare will attempt to
  #                match it on the server-side
  #   :shout    => (optional) a message about your check-in
  #   :private  => (optional, defaults to the user's setting). true means
  #                "don't show your friends". false means "show everyone"
  #   :twitter  => (optional, defaults to the user's setting). false means
                   # "send to twitter". false means "don't send to twitter"
  #   :geolat   => (optional, but recommended)
  #   :geolong  => (optional, but recommended)
  def checkin(options = {})
    unless options[:private].nil?
      options[:private] = 1 if options[:private] == true
      options[:private] = 0 if options[:private] == false
    end
    unless options[:twitter].nil?
      options[:twitter] = 1 if options[:twitter] == true
      options[:twitter] = 0 if options[:twitter] == false
    end
    response = self.class.post("/checkin.json",
                               :query => options,
                               :basic_auth => @auth)
    raise VenueNotFoundError if response.keys.include?("addvenueprompt")
    response["checkin"]
  end

  # Like self.venues(), except when authenticated the method will return venue
  # meta-data related to you and your friends.
  def venues(options = {})
    self.class.require_latitude_and_longitude(options)

    response = self.class.get("/venues.json",
                              :query => options,
                              :basic_auth => @auth)["venues"]
    response && response.flatten
  end

  ############################################################################
  # Class methods
  ############################################################################

  # Returns a list of currently active cities.
  # http://api.playfoursquare.com/v1/cities
  def self.cities
    get("/cities.json", :query => nil)["cities"]
  end

  # Returns a list of venues near the area specified or that match the search
  # term. Distance returned is in miles. It will return venue meta-data
  # related to you and your friends.
  #
  # Options
  #   :geolat   => latitude (required)
  #   :geolong  => longitude (required)
  #   :r        => radius in miles (optional)
  #   :l        => limit of results (optional, default 10)
  #   :q        => keyword search (optional)
  def self.venues(options = {})
    require_latitude_and_longitude(options)

    get("/venues.json", :query => options)["venues"]["group"]
  end

  # Test if API is up and available
  # http://api.playfoursquare.com/v1/test
  def self.available?
    response = get("/test.json", :query => nil)
    (!response.nil? && response["response"] == "ok") ? true : false
  end

  private

  def self.require_latitude_and_longitude(options)
    unless options[:geolat] and options[:geolong]
      raise ArgumentError, "you must supply :geolat and :geolong"
    end
  end
end