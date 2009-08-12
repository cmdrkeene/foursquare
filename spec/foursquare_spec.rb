require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../init'

describe Foursquare do
  describe ".checkin" do
    before do
      @valid_venue_id   = 84689
      @invalid_venue_id = 111
      @username = "user@example.com"
      @password = "secret"

      # Success
      FakeWeb.register_uri(:post,
                           "http://api.playfoursquare.com/v1/checkin.json?vid=#{@valid_venue_id}",
                           :body => "Unauthorized",
                           :status => ["401", "Unauthorized"])
      FakeWeb.register_uri(:post,
                           "http://user%40example.com:secret@api.playfoursquare.com/v1/checkin.json?vid=#{@valid_venue_id}",
                           :body => fakeweb_read('checkin_success.json'))

      # Failure
      FakeWeb.register_uri(:post,
                           "http://api.playfoursquare.com/v1/checkin.json?vid=#{@invalid_venue_id}",
                           :body => "Unauthorized",
                           :status => ["401", "Unauthorized"])
      FakeWeb.register_uri(:post,
                           "http://user%40example.com:secret@api.playfoursquare.com/v1/checkin.json?vid=#{@invalid_venue_id}",
                           :body => fakeweb_read('checkin_failure.json'))
    end
    
    it "should require a venue_id" do
      lambda {
        Foursquare.new(@username, @password).checkin
      }.should raise_error(ArgumentError)
    end
    
    it "should raise an error if user is invalid" do
      lambda {
        Foursquare.new("bork@pork.com", "arglebargle").checkin(@valid_venue_id)
      }.should raise_error
    end
    
    describe "to a valid venue, with a valid user" do
      it "should check in and return check in data" do
        @foursquare = Foursquare.new(@username, @password)
        checkin = @foursquare.checkin(@valid_venue_id)
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
          @foursquare.checkin(@invalid_venue_id).should == "foo"
        }.should raise_error(Foursquare::VenueNotFoundError)
      end
    end
  end

  describe ".city" do
  end

  describe ".tip" do
  end
  
  describe ".user" do
  end
    
  describe ".venue" do
  end
end