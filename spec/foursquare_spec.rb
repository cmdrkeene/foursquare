require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../init'

describe Foursquare do
  before do
    @username = "user@example.com"
    @password = "secret"
  end
  
  describe ".checkin" do
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
      Foursquare.new.cities.should == cities
      Foursquare.cities.should == cities
    end
  end

  describe ".tip" do
  end
  
  describe ".user" do
  end
    
  describe ".venue" do
  end
end