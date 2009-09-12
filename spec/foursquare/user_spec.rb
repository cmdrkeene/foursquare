require File.dirname(__FILE__) + '/../spec_helper'

describe Foursquare::User do
  describe ".find" do
    before do
      @username = 'user@example.com'
      @password = 'secret'
      Foursquare::Base.connect(@username, @password)
    end
    
    it "should return user data for an arbitrary user" do
      FakeWeb.register_uri(:get,
                           "http://api.playfoursquare.com/v1/user.json?uid=31786",
                           :body => fakeweb_read('user.json'))
      
      Foursquare::User.find(:uid => 31786).should == {
        "city" => {"shortname"=>"San Diego", 
                   "name"=>"San Diego",
                   "geolong"=>-117.156,
                   "geolat"=>32.7153, "id"=>38},
        "gender"=>"none",
        "lastname"=>"Connor",
        "id"=>31786,
        "checkin"=>{"shout"=>nil,
                    "id"=>707746,
                    "display"=>"John C. @ Santana's Mexican Grill (Bay Park)",
                    "venue"=>{"address"=>"1975 Morena Blvd",
                              "name"=>"Santana's Mexican Grill (Bay Park)", 
                              "geolong"=>-117.207,
                              "geolat"=>32.782,
                              "crossstreet"=>"Napier St",
                              "id"=>84689},
        "created"=>"Wed, 12 Aug 09 10:21:33 +0000"},
        "firstname"=>"John",
        "settings"=>{"feeds_key"=>"9c0cf605ddd2251495640129c7c40c6e"}}
    end

    it "should return user data for the authenticated user" do
      FakeWeb.register_uri(:get,
                           "http://api.playfoursquare.com/v1/user.json",
                           :body => fakeweb_read('user.json'))
      
      Foursquare::User.find == {
        "city" => {"shortname"=>"San Diego", 
                   "name"=>"San Diego",
                   "geolong"=>-117.156,
                   "geolat"=>32.7153, "id"=>38},
        "gender"=>"none",
        "lastname"=>"Connor",
        "id"=>31786,
        "checkin"=>{"shout"=>nil,
                    "id"=>707746,
                    "display"=>"John C. @ Santana's Mexican Grill (Bay Park)",
                    "venue"=>{"address"=>"1975 Morena Blvd",
                              "name"=>"Santana's Mexican Grill (Bay Park)", 
                              "geolong"=>-117.207,
                              "geolat"=>32.782,
                              "crossstreet"=>"Napier St",
                              "id"=>84689},
        "created"=>"Wed, 12 Aug 09 10:21:33 +0000"},
        "firstname"=>"John",
        "settings"=>{"feeds_key"=>"9c0cf605ddd2251495640129c7c40c6e"}}
    end
  end
end
