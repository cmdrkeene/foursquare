require File.dirname(__FILE__) + '/../spec_helper'

describe Foursquare::Base do
  describe "connect" do
    it "should set authentication hash" do
      Foursquare::Base.connect('example', 'sekret')
      Foursquare::Base.authentication.should == {
        :username => 'example',
        :password => 'sekret'
      }
    end
  end
  
  describe "location" do
    before do
      Foursquare::Base.location = [25.7323, -80.2436]
    end
    
    it "should convert into a GeoKit::LatLng instance" do
      Foursquare::Base.location.should be_a_kind_of(GeoKit::LatLng)
    end
    
    it "should get latitude from location" do
      Foursquare::Base.latitude.should == 25.7323
    end
    
    it "should get longitude from location" do
      Foursquare::Base.longitude.should == -80.2436
    end
  end
  
  describe ".extract_options" do
    it "should extract options hash from args" do
      Foursquare::Base.send(:extract_options).should == {}
      Foursquare::Base.send(:extract_options, :all).should == {}
      Foursquare::Base.send(:extract_options, :first).should == {}
      Foursquare::Base.send(:extract_options, :all, {:search=>"foo"}).should == {:search => 'foo'}
      Foursquare::Base.send(:extract_options, [:all, {:search=>"foo"}]).should == {:search => 'foo'}
      Foursquare::Base.send(:extract_options, :all, :name => 'foo').should == {:name => 'foo'}
      Foursquare::Base.send(:extract_options, :all, :name => 'foo', :limit => 10).should == {:name => 'foo', :limit => 10}
    end
  end
end
