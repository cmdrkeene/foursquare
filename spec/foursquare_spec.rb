require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../init'

describe Foursquare do
  before do
    @username = "user@example.com"
    @password = "secret"
  end

  describe "#checkin" do
    before do
      @valid_vid   = 84689
      @invalid_vid = 111

      # Success
      FakeWeb.register_uri(:post,
                           "http://api.playfoursquare.com/v1/checkin.json?vid=#{@valid_vid}",
                           :body => "Unauthorized",
                           :status => ["401", "Unauthorized"])
      FakeWeb.register_uri(:post,
                           "http://user%40example.com:secret@api.playfoursquare.com/v1/checkin.json?vid=#{@valid_vid}",
                           :body => fakeweb_read('checkin_success.json'))

      # Failure
      FakeWeb.register_uri(:post,
                           "http://api.playfoursquare.com/v1/checkin.json?vid=#{@invalid_vid}",
                           :body => "Unauthorized",
                           :status => ["401", "Unauthorized"])
      FakeWeb.register_uri(:post,
                           "http://user%40example.com:secret@api.playfoursquare.com/v1/checkin.json?vid=#{@invalid_vid}",
                           :body => fakeweb_read('checkin_failure.json'))
    end

    it "should raise an error if user is invalid" do
      lambda {
        Foursquare.new("bork@pork.com", "arglebargle").checkin(@valid_vid)
      }.should raise_error
    end

    describe "to a valid venue, with a valid user" do
      it "should check in and return check in data" do
        @foursquare = Foursquare.new(@username, @password)
        checkin = @foursquare.checkin(:vid => @valid_vid)
        checkin.should == {
          "mayor"     => {"type"=>"nochange", "message"=>"Casey W. is The Mayor of Santana's Bay Park."},
          "scoring"   => {
            "score" => {"icon"=>"http://playfoursquare.com/images/scoring/2.png", "points"=>1, "message"=>"First stop today"},
            "total" => {"points"=>6, "message"=>"6 pts "},
            "rank"  => {
              "city"    => {"city"=>"San Diego", "position"=>42, "message"=>"#42 in San Diego (this week)"},
              "friends" => {"position"=>1, "message"=>"#1 amongst friends"}
            },
          },
          "id" => 701707,
          "badges" => {
            "badge" => {"name"=>"Newbie", "text"=>"Congrats on your first check-in!", "icon"=>"http://playfoursquare.com/images/badges/newbie_on.png", "id"=>54494}
          },
          "venue" => {"city"=>"San Diego", "address"=>"1975 Morena Blvd.", "name"=>"Santana's Bay Park", "zip"=>92110, "geolong"=>-117.207, "geolat"=>32.782, "crossstreet"=>nil, "id"=>84689, "cityid"=>38, "state"=>"CA"},
          "message" => "OK! We've got you @ Santana's Bay Park.", "created"=>"Tue, 11 Aug 09 16:02:13 +0000"
        }
      end
    end

    describe "with an invalid venue" do
      it "should raise an error" do
        lambda {
          @foursquare = Foursquare.new(@username, @password)
          @foursquare.checkin(:vid => @invalid_vid).should == "foo"
        }.should raise_error(Foursquare::VenueNotFoundError)
      end
    end
  end

  describe ".cities" do
    before do
      FakeWeb.register_uri(:get,
                           "http://api.playfoursquare.com/v1/cities.json?",
                           :body => fakeweb_read('cities.json'))
    end

    it "should return all cities currently active on Foursquare" do
      cities = [
        {"name"=>"Amsterdam", "geolong"=>4.90067, "geolat"=>52.3789, "timezone"=>"Europe/Amsterdam", "id"=>56},
        {"name"=>"Atlanta", "geolong"=>-84.3888, "geolat"=>33.7525, "timezone"=>"America/New_York", "id"=>46},
        {"name"=>"Austin", "geolong"=>-97.7428, "geolat"=>30.2669, "timezone"=>"America/Chicago", "id"=>42},
        {"name"=>"Boston", "geolong"=>-71.0603, "geolat"=>42.3583, "timezone"=>"America/New_York", "id"=>24},
        {"name"=>"Chicago", "geolong"=>-87.6181, "geolat"=>41.8858, "timezone"=>"America/Chicago", "id"=>32},
        {"name"=>"Dallas / Fort Worth", "geolong"=>-96.7676, "geolat"=>32.7887, "timezone"=>"America/Chicago", "id"=>43},
        {"name"=>"Denver", "geolong"=>-105.026, "geolat"=>39.734, "timezone"=>"America/Denver", "id"=>25},
        {"name"=>"Detroit", "geolong"=>-83.0484, "geolat"=>42.3333, "timezone"=>"America/New_York", "id"=>47},
        {"name"=>"Houston", "geolong"=>-95.3594, "geolat"=>29.7594, "timezone"=>"America/Chicago", "id"=>48},
        {"name"=>"Las Vegas", "geolong"=>-115.122, "geolat"=>36.1721, "timezone"=>"America/Los_Angeles", "id"=>49},
        {"name"=>"Los Angeles", "geolong"=>-118.251, "geolat"=>34.0443, "timezone"=>"America/Los_Angeles", "id"=>34},
        {"name"=>"Miami", "geolong"=>-80.2436, "geolat"=>25.7323, "timezone"=>"America/New_York", "id"=>39},
        {"name"=>"Minneapolis / St. Paul", "geolong"=>-93.2642, "geolat"=>44.9609, "timezone"=>"America/Chicago", "id"=>51},
        {"name"=>"New York City", "geolong"=>-73.9983, "geolat"=>40.7255, "timezone"=>"America/New_York", "id"=>22},
        {"name"=>"Philadelphia", "geolong"=>-75.2731, "geolat"=>39.8694, "timezone"=>"America/New_York", "id"=>33},
        {"name"=>"Phoenix", "geolong"=>-112.073, "geolat"=>33.4483, "timezone"=>"America/Phoenix", "id"=>53},
        {"name"=>"Portland", "geolong"=>-122.685, "geolat"=>45.527, "timezone"=>"America/Los_Angeles", "id"=>37},
        {"name"=>"San Diego", "geolong"=>-117.156, "geolat"=>32.7153, "timezone"=>"America/Los_Angeles", "id"=>38},
        {"name"=>"San Francisco", "geolong"=>-122.433, "geolat"=>37.7587, "timezone"=>"America/Los_Angeles", "id"=>23},
        {"name"=>"Seattle", "geolong"=>-122.326, "geolat"=>47.6036, "timezone"=>"America/Los_Angeles", "id"=>41},
        {"name"=>"Washington, DC", "geolong"=>-77.0447, "geolat"=>38.8964, "timezone"=>"America/New_York", "id"=>31}
      ]
      Foursquare.cities.should == cities
    end
  end

  describe ".tip" do
  end

  describe ".user" do
  end

  describe "#user" do
  end

  describe ".venue" do
    before do
      FakeWeb.register_uri(:get,
                           "http://api.playfoursquare.com/v1/venues.json?geolat=25.7323&geolong=80.2436",
                           :body => fakeweb_read('venues_unauthenticated.json'))
    end

    it "should raise an error unless geolat and geolong are passed" do
      lambda {
        Foursquare.venues
      }.should raise_error(ArgumentError)
    end

    it "should return a list of nearby venues" do
      venues = [
        {"city"=>"Miami", "address"=>"3339 Virginia St", "name"=>"InfiniHQ", "zip"=>33133, "geolong"=>-80.2413, "geolat"=>25.7292, "crossstreet"=>"at Oak Ave", "id"=>84676, "phone"=>3057284641, "state"=>"FL", "distance"=>0.3},
        {"city"=>"Miami", "address"=>"3342 Virginia St", "name"=>"Life", "zip"=>33133, "geolong"=>-80.2415, "geolat"=>25.7289, "crossstreet"=>nil, "id"=>10252, "phone"=>nil, "state"=>"FL", "distance"=>0.3},
        {"city"=>"Miami", "address"=>"3064 Grand Ave", "name"=>"Sandbar", "zip"=>33133, "geolong"=>-80.2428, "geolat"=>25.7281, "crossstreet"=>nil, "id"=>10350, "phone"=>nil, "state"=>"FL", "distance"=>0.3},
        {"city"=>"Miami", "address"=>"2911 Grand Ave", "name"=>"Oxygen Lounge", "zip"=>33133, "geolong"=>-80.2406, "geolat"=>25.7285, "crossstreet"=>nil, "id"=>10305, "phone"=>nil, "state"=>"FL", "distance"=>0.3},
        {"city"=>"Coconut Grove", "address"=>"3415 Main Hwy", "name"=>"Boardwalk Tavern & Pizzeria", "zip"=>33133, "geolong"=>-80.2427, "geolat"=>25.7277, "crossstreet"=>nil, "id"=>45598, "phone"=>"305-567-0080", "state"=>"FL", "distance"=>0.3},
        {"city"=>"Miami", "address"=>"3035 Fuller St,", "name"=>"Barracadu Bar & Grill }i{", "zip"=>33133, "geolong"=>-80.2432, "geolat"=>25.7276, "crossstreet"=>"btw Main Hwy and Grand ave", "id"=>88408, "phone"=>"(305) 448-1144", "state"=>"FL", "distance"=>0.3},
        {"city"=>"Miami", "address"=>"3035 Fuller St", "name"=>"Barracadu Coconut Grove}i{", "zip"=>nil, "geolong"=>-80.2432, "geolat"=>25.7276, "crossstreet"=>"btw Main Hwy and Grand ave", "id"=>85556, "phone"=>"(305) 448-1144", "state"=>"FL", "distance"=>0.3},
        {"city"=>"Miami", "address"=>"3035 Fuller St", "name"=>"Barracuda Bar", "zip"=>33133, "geolong"=>-80.2432, "geolat"=>25.7276, "crossstreet"=>"at Grand Ave", "id"=>18315, "phone"=>"305 448-1144", "state"=>"FL", "distance"=>0.3},
        {"city"=>"Miami", "address"=>"3424 Main Highway", "name"=>"Hungry Sailor", "zip"=>33133, "geolong"=>-80.2428, "geolat"=>25.7276, "crossstreet"=>nil, "id"=>10219, "phone"=>nil, "state"=>"FL", "distance"=>0.3},
        {"city"=>"Miami", "address"=>"3416 Main Highway", "name"=>"Tavern In The Grove", "zip"=>33133, "geolong"=>-80.2427, "geolat"=>25.7276, "crossstreet"=>nil, "id"=>10391, "phone"=>nil, "state"=>"FL", "distance"=>0.3},
        {"city"=>"Miami", "address"=>"2801 Florida Ave", "name"=>"Quench", "zip"=>33133, "geolong"=>-80.2395, "geolat"=>25.7291, "crossstreet"=>nil, "id"=>10331, "phone"=>"305 448-8150", "state"=>"FL", "distance"=>0.3},
        {"city"=>"Miami", "address"=>"3131 Commodore Plaza", "name"=>"Mr. Moe's", "zip"=>33133, "geolong"=>-80.2441, "geolat"=>25.7274, "crossstreet"=>nil, "id"=>10287, "phone"=>nil, "state"=>"FL", "distance"=>0.3},
        {"city"=>"Miami", "address"=>"3120 Commodore Plaza", "name"=>"Don Quixote", "zip"=>33133, "geolong"=>-80.2447, "geolat"=>25.7271, "crossstreet"=>nil, "id"=>10147, "phone"=>nil, "state"=>"FL", "distance"=>0.4},
        {"city"=>"Miami", "address"=>"2895 McFarlane RD.", "name"=>"Flavour", "zip"=>33133, "geolong"=>-80.2411, "geolat"=>25.7275, "crossstreet"=>nil, "id"=>10173, "phone"=>nil, "state"=>"FL", "distance"=>0.4},
        {"city"=>"Miami", "address"=>"3480 Main Highway", "name"=>"Senor Frogs", "zip"=>33133, "geolong"=>-80.2442, "geolat"=>25.7267, "crossstreet"=>nil, "id"=>10356, "phone"=>nil, "state"=>"FL", "distance"=>0.4},
        {"city"=>"Miami", "address"=>"3390 Mary St", "name"=>"Improv Comedy Club", "zip"=>33133, "geolong"=>-80.2393, "geolat"=>25.7282, "crossstreet"=>nil, "id"=>10224, "phone"=>nil, "state"=>"FL", "distance"=>0.4},
        {"city"=>"Miami", "address"=>"2700 south bayshore drive", "name"=>"Cocont Grove Expo Center", "zip"=>33133, "geolong"=>-80.2379, "geolat"=>25.7282, "crossstreet"=>nil, "id"=>10124, "phone"=>nil, "state"=>"FL", "distance"=>0.5},
        {"city"=>"Coconut Grove", "address"=>"Grand Ave", "name"=>"The Jewlicious Pad", "zip"=>nil, "geolong"=>-80.2499, "geolat"=>25.7278, "crossstreet"=>nil, "id"=>80526, "phone"=>nil, "twitter"=>"jewgonewild", "state"=>"FL", "distance"=>0.5},
        {"city"=>"Miami", "address"=>"3540 Main Highway", "name"=>"Taurus Chops", "zip"=>33133, "geolong"=>-80.245, "geolat"=>25.7251, "crossstreet"=>nil, "id"=>10390, "phone"=>nil, "state"=>"FL", "distance"=>0.5},
        {"city"=>"Miami", "address"=>"2649 South Bayshore Drive", "name"=>"Doubletree Coconut Grove", "zip"=>33133, "geolong"=>-80.2353, "geolat"=>25.7312, "crossstreet"=>nil, "id"=>83833, "phone"=>"305-858-2500", "state"=>"FL", "distance"=>0.5}
      ]
      Foursquare.venues(:geolat => 25.7323, :geolong => 80.2436)
    end
  end

  describe "#venue" do
    before do
      FakeWeb.register_uri(:get,
                           "http://user%40example.com:secret@api.playfoursquare.com/v1/venues.json?geolat=25.7323&geolong=80.2436",
                           :body => fakeweb_read('venues_authenticated.json'))
    end

    it "should return venues with user metadata" do
      venues_with_user_data = [
        {"city"=>"Miami", "address"=>"3064 Grand Ave", "name"=>"Sandbar", "zip"=>33133, "stats"=>{"checkins"=>18}, "geolong"=>-80.2428, "geolat"=>25.7281, "crossstreet"=>nil, "id"=>10350, "phone"=>nil, "state"=>"FL", "distance"=>0.1},
        {"city"=>"Miami", "address"=>"3131 Commodore Plaza", "name"=>"Mr. Moe's", "zip"=>33133, "stats"=>{"checkins"=>6}, "geolong"=>-80.2441, "geolat"=>25.7274, "crossstreet"=>nil, "id"=>10287, "phone"=>nil, "state"=>"FL", "distance"=>0.1},
        {"city"=>"Miami", "address"=>"3035 Fuller St", "name"=>"Barracuda Bar", "zip"=>33133, "stats"=>{"checkins"=>4}, "geolong"=>-80.2432, "geolat"=>25.7276, "crossstreet"=>"at Grand Ave", "id"=>18315, "phone"=>"305 448-1144", "state"=>"FL", "distance"=>0.1},
        {"city"=>"Coconut Grove", "address"=>"3415 Main Hwy", "name"=>"Boardwalk Tavern & Pizzeria", "zip"=>33133, "stats"=>{"checkins"=>3}, "geolong"=>-80.2427, "geolat"=>25.7277, "crossstreet"=>nil, "id"=>45598, "phone"=>"305-567-0080", "state"=>"FL", "distance"=>0.1},
        {"city"=>"Miami", "address"=>"3035 Fuller St,", "name"=>"Barracadu Bar & Grill }i{", "zip"=>33133, "geolong"=>-80.2432, "geolat"=>25.7276, "crossstreet"=>"btw Main Hwy and Grand ave", "id"=>88408, "phone"=>"(305) 448-1144", "state"=>"FL", "distance"=>0.1},
        {"city"=>"Miami", "address"=>"3035 Fuller St", "name"=>"Barracadu Coconut Grove}i{", "zip"=>nil, "geolong"=>-80.2432, "geolat"=>25.7276, "crossstreet"=>"btw Main Hwy and Grand ave", "id"=>85556, "phone"=>"(305) 448-1144", "state"=>"FL", "distance"=>0.1},
        {"city"=>"Miami", "address"=>"3120 Commodore Plaza", "name"=>"Don Quixote", "zip"=>33133, "geolong"=>-80.2447, "geolat"=>25.7271, "crossstreet"=>nil, "id"=>10147, "phone"=>nil, "state"=>"FL", "distance"=>0.1},
        {"city"=>"Miami", "address"=>"3424 Main Highway", "name"=>"Hungry Sailor", "zip"=>33133, "geolong"=>-80.2428, "geolat"=>25.7276, "crossstreet"=>nil, "id"=>10219, "phone"=>nil, "state"=>"FL", "distance"=>0.1},
        {"city"=>"Miami", "address"=>"3416 Main Highway", "name"=>"Tavern In The Grove", "zip"=>33133, "geolong"=>-80.2427, "geolat"=>25.7276, "crossstreet"=>nil, "id"=>10391, "phone"=>nil, "state"=>"FL", "distance"=>0.1},
        {"city"=>"Miami", "address"=>"3480 Main Highway", "name"=>"Senor Frogs", "zip"=>33133, "geolong"=>-80.2442, "geolat"=>25.7267, "crossstreet"=>nil, "id"=>10356, "phone"=>nil, "state"=>"FL", "distance"=>0.1},
        {"city"=>"Miami", "address"=>"3342 Virginia St", "name"=>"Life", "zip"=>33133, "geolong"=>-80.2415, "geolat"=>25.7289, "crossstreet"=>nil, "id"=>10252, "phone"=>nil, "state"=>"FL", "distance"=>0.2},
        {"city"=>"Miami", "address"=>"3339 Virginia St", "name"=>"InfiniHQ", "zip"=>33133, "geolong"=>-80.2413, "geolat"=>25.7292, "crossstreet"=>"at Oak Ave", "id"=>84676, "phone"=>3057284641, "state"=>"FL", "distance"=>0.2},
        {"city"=>"Miami", "address"=>"2895 McFarlane RD.", "name"=>"Flavour", "zip"=>33133, "geolong"=>-80.2411, "geolat"=>25.7275, "crossstreet"=>nil, "id"=>10173, "phone"=>nil, "state"=>"FL", "distance"=>0.2},
        {"city"=>"Miami", "address"=>"3540 Main Highway", "name"=>"Taurus Chops", "zip"=>33133, "geolong"=>-80.245, "geolat"=>25.7251, "crossstreet"=>nil, "id"=>10390, "phone"=>nil, "state"=>"FL", "distance"=>0.2},
        {"city"=>"Miami", "address"=>"2911 Grand Ave", "name"=>"Oxygen Lounge", "zip"=>33133, "geolong"=>-80.2406, "geolat"=>25.7285, "crossstreet"=>nil, "id"=>10305, "phone"=>nil, "state"=>"FL", "distance"=>0.2},
        {"city"=>"Miami", "address"=>"2801 Florida Ave", "name"=>"Quench", "zip"=>33133, "geolong"=>-80.2395, "geolat"=>25.7291, "crossstreet"=>nil, "id"=>10331, "phone"=>"305 448-8150", "state"=>"FL", "distance"=>0.3},
        {"city"=>"Miami", "address"=>"3390 Mary St", "name"=>"Improv Comedy Club", "zip"=>33133, "geolong"=>-80.2393, "geolat"=>25.7282, "crossstreet"=>nil, "id"=>10224, "phone"=>nil, "state"=>"FL", "distance"=>0.3},
        {"city"=>"Coconut Grove", "address"=>"Grand Ave", "name"=>"The Jewlicious Pad", "zip"=>nil, "geolong"=>-80.2499, "geolat"=>25.7278, "crossstreet"=>nil, "id"=>80526, "phone"=>nil, "twitter"=>"jewgonewild", "state"=>"FL", "distance"=>0.4},
        {"city"=>"Miami", "address"=>"2700 south bayshore drive", "name"=>"Cocont Grove Expo Center", "zip"=>33133, "geolong"=>-80.2379, "geolat"=>25.7282, "crossstreet"=>nil, "id"=>10124, "phone"=>nil, "state"=>"FL", "distance"=>0.4},
        {"city"=>"Miami", "address"=>"650 williamstreet", "name"=>"Flordia", "zip"=>nil, "geolong"=>-80.2511, "geolat"=>25.7263, "crossstreet"=>"Sr mia", "id"=>66946, "phone"=>nil, "state"=>"FL", "distance"=>0.4},
        {"city"=>"Miami", "address"=>"2649 South Bayshore Drive", "name"=>"Doubletree Coconut Grove", "zip"=>33133, "geolong"=>-80.2353, "geolat"=>25.7312, "crossstreet"=>nil, "id"=>83833, "phone"=>"305-858-2500", "state"=>"FL", "distance"=>0.6},
        {"city"=>"Coconut grove", "address"=>"3381 pan American drive", "name"=>"Scottys Landing", "zip"=>33133, "geolong"=>-80.2342, "geolat"=>25.7278, "crossstreet"=>nil, "id"=>86452, "phone"=>nil, "state"=>"FL", "distance"=>0.6},
        {"city"=>"Miami", "address"=>"2550 South Bayshore Drive", "name"=>"Monty's", "zip"=>33133, "geolong"=>-80.2326, "geolat"=>25.7321, "crossstreet"=>nil, "id"=>18241, "phone"=>"305 858-1431", "state"=>"FL", "distance"=>0.8},
        {"city"=>"Miami", "address"=>"2884 S.W. 27th Ave", "name"=>"Berries in the Grove }i{", "zip"=>33133, "geolong"=>-80.2381, "geolat"=>25.7382, "crossstreet"=>"btw US1 and Coconut ave", "id"=>85554, "phone"=>"(305) 448-2111", "state"=>"FL", "distance"=>0.8}
      ]

      @foursquare = Foursquare.new(@username, @password)
      @foursquare.venues(:geolat => "25.7323", :geolong => "80.2436").should == venues_with_user_data
    end
  end
end