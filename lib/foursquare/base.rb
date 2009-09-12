module Foursquare #:nodoc:
  class Base
    def self.connect(username, password)
      @@authentication = {:username => username, :password => password}
    end

    def self.location=(location)
      @@location = GeoKit::LatLng.normalize(location)
    end
    
    def self.authentication
      @@authentication
    end    
    
    def self.location
      @@location
    end
    
    def self.latitude
      location.lat
    end
    
    def self.longitude
      location.lng
    end
    
    private
    
    def self.get(*args)
      Foursquare.get(*args)
    end

    def self.post(*args)
      Foursquare.post(*args)
    end
    
    # Ripped from ActiveSupport::CoreExtensions::Array::ExtractOptions
    def self.extract_options(*args)
      args.flatten!
      args.last.is_a?(::Hash) ? args.pop : {}
    end
  end
end