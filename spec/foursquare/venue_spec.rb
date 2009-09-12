require File.dirname(__FILE__) + '/../spec_helper'

describe Foursquare::Venue do
  before do
    FakeWeb.register_uri(:get,
                         "http://api.playfoursquare.com/v1/venues.json?geolat=25.7323&geolong=-80.2436",
                         :body => fakeweb_read('venues_unauthenticated.json'))
    Foursquare::Base.location = [25.7323, -80.2436] # Miami, FL
  end
  
  it "should initialize from hash" do
    venue = Foursquare::Venue.new("city"        => "Miami",
                                  "address"     => "3339 Virginia St",
                                  "name"        => "InfiniHQ",
                                  "zip"         => 33133,
                                  "geolong"     => -80.2413,
                                  "geolat"      => 25.7292,
                                  "crossstreet" => "at Oak Ave",
                                  "id"          => 84676,
                                  "phone"       => 3057284641,
                                  "state"       => "FL",
                                  "distance"    => 0.3)
    venue.city.should == "Miami"
    venue.address.should == "3339 Virginia St"
    venue.name.should == "InfiniHQ"
    venue.zip.should == 33133
    venue.longitude.should == -80.2413
    venue.latitude.should == 25.7292
    venue.cross_street.should == "at Oak Ave"
    venue.id.should == 84676
    venue.phone.should == 3057284641
    venue.state.should == "FL"
    venue.distance.should == 0.3
  end
  
  describe ".find" do    
    describe ":all" do
      it "should return a list of venues" do
        # JSON response => array of venue hashes
        # [{"city"=>"Miami", "address"=>"3339 Virginia St", "name"=>"InfiniHQ", "zip"=>33133, "geolong"=>-80.2413, "geolat"=>25.7292, "crossstreet"=>"at Oak Ave", "id"=>84676, "phone"=>3057284641, "state"=>"FL", "distance"=>0.3}, ...]
        venues = Foursquare::Venue.find(:all)
        
        # Collection
        venues.size.should == 20
        
        # Venue
        venue = venues.first
        venue.should be_a_kind_of(Foursquare::Venue)
        venue.city.should == "Miami"
        venue.address.should == "3339 Virginia St"
        venue.name.should == "InfiniHQ"
        venue.zip.should == 33133
        venue.longitude.should == -80.2413
        venue.latitude.should == 25.7292
        venue.cross_street.should == "at Oak Ave"
        venue.id.should == 84676
        venue.phone.should == 3057284641
        venue.state.should == "FL"
        venue.distance.should == 0.3
      end
      
      describe "when authenticated" do
        it "should pull user specific data"
      end
      
      describe "with options" do
        it "converts :search option to :q" do
          FakeWeb.register_uri(:get,
                               "http://api.playfoursquare.com/v1/venues.json?geolong=-80.2436&q=foo&geolat=25.7323",
                               :body => fakeweb_read('venues_unauthenticated.json'))          
          Foursquare::Venue.find(:all, :search => 'foo').size.should == 20
        end
        
        it "converts :radius option to :r" do
          FakeWeb.register_uri(:get,
                               "http://api.playfoursquare.com/v1/venues.json?geolong=-80.2436&r=10&geolat=25.7323",
                               :body => fakeweb_read('venues_unauthenticated.json'))          
          Foursquare::Venue.find(:all, :radius => 10).size.should == 20
          
        end
        
        it "converts :limit option to :l" do
          FakeWeb.register_uri(:get,
                               "http://api.playfoursquare.com/v1/venues.json?geolong=-80.2436&l=20&geolat=25.7323",
                               :body => fakeweb_read('venues_unauthenticated.json'))          
          Foursquare::Venue.find(:all, :limit => 20).size.should == 20          
        end
        
        it "converts :near condition (a normalizeable GeoKit object) to :geolat, :geolong" do
          FakeWeb.register_uri(:get,
                               "http://api.playfoursquare.com/v1/venues.json?geolong=-70&geolat=20",
                               :body => fakeweb_read('venues_unauthenticated.json'))          
          Foursquare::Venue.find(:all, :near => [20, -70]).size.should == 20                    
        end
      end
    end
    
    describe ":first" do
      it "should return a single venue" do
        FakeWeb.register_uri(:get,
                             "http://api.playfoursquare.com/v1/venues.json?geolat=25.7323&geolong=-80.2436&l=1",
                             :body => fakeweb_read('venues_unauthenticated.json'))
        
        venue = Foursquare::Venue.find(:first)
        venue.should be_a_kind_of(Foursquare::Venue)
      end
    end
  end
    
  describe "#checkin" do
    it "should check the authenticated user into the venue"
  end
end