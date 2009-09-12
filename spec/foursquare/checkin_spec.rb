require File.dirname(__FILE__) + '/../spec_helper'

describe Foursquare::Checkin do
  describe ".create" do
    before do
      # TODO commonize these, cleanup URI strings
      @username     = 'user@example.com'
      @password     = 'secret'
      @valid_vid    = 84689
      @invalid_vid  = 111

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
        Foursquare.connect("bork@pork.com", "arglebargle")
      }.should raise_error
    end

    describe "to a valid venue, with a valid user" do
      before do
        Foursquare::Base.connect(@username, @password)
        @checkin = Foursquare::Checkin.create(:vid => @valid_vid)                
      end
      
      it "should check in and return check in data" do
        @checkin.id.should == 701707
        @checkin.message.should == "OK! We've got you @ Santana's Bay Park."
        @checkin.created_at.should == Time.parse("Tue, 11 Aug 09 16:02:13 +0000")
      end
      
      it "parses venue response" do
        @checkin.venue.should be_a_kind_of(Foursquare::Venue)
        @checkin.venue.name.should == "Santana's Bay Park"
      end
      
      it "parses badges response" do
        @checkin.badges.size.should == 1
        @checkin.badges.first.should == {
          "name"  => "Newbie",
          "text"  => "Congrats on your first check-in!",
          "icon"  => "http://playfoursquare.com/images/badges/newbie_on.png",
          "id"    => 54494
        }
      end
        
      it "parses scoring response" do
        @checkin.scoring.should == {
          "score" => {
            "icon"    => "http://playfoursquare.com/images/scoring/2.png",
            "points"  =>1,
            "message" =>"First stop today"
          },
          "total" => {
            "points"  => 6,
            "message" => "6 pts "
          },
          "rank"  => {
            "city"    => {
              "city"      => "San Diego",
              "position"  => 42,
              "message"   => "#42 in San Diego (this week)"
            },
            "friends" => {
              "position"  => 1,
              "message"   => "#1 amongst friends"
            }
          }
        }
      end
      
      it "parses mayor response" do
        @checkin.mayor.should == {"type"=>"nochange", "message"=>"Casey W. is The Mayor of Santana's Bay Park."}
      end
    end

    describe "with an invalid venue" do
      it "should raise a record not found exception" do
        lambda {
          Foursquare::Base.connect(@username, @password)
          Foursquare::Checkin.create(:vid => @invalid_vid).should == "foo"
        }.should raise_error(Foursquare::RecordNotFound)
      end
    end
  end
end