require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../init'

describe Foursquare do

  describe ".cities" do
    before do
      FakeWeb.register_uri(:get,
                           "http://api.playfoursquare.com/v1/cities.json",
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
  
  describe ".available?" do
    it "it should return true when foursquare is up" do
      FakeWeb.register_uri(:get,
                           "http://api.playfoursquare.com/v1/test.json",
                           :body => fakeweb_read('test_success.json'))

      Foursquare.should be_available
    end

    it "should return false when foursquare is down" do
      FakeWeb.register_uri(:get,
                           "http://api.playfoursquare.com/v1/test.json",
                           :body => fakeweb_read('test_failure.json'))
      Foursquare.should_not be_available
    end
  end
end