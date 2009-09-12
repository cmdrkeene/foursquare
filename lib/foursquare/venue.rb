module Foursquare
  class Venue < Base    
    def self.attribute_names
      [:id,
       :name,
       :address,
       :city,
       :state,
       :zip,
       :cross_street,
       :phone,
       :latitude,
       :longitude,
       :distance]
    end
    
    attr_accessor *attribute_names
    
    def initialize(attributes = nil)
      if attributes
        self.id           = attributes['id']
        self.name         = attributes['name']
        self.address      = attributes['address']
        self.city         = attributes['city']
        self.state        = attributes['state']
        self.zip          = attributes['zip']
        self.cross_street = attributes['crossstreet']
        self.phone        = attributes['phone']
        self.latitude     = attributes['geolat']
        self.longitude    = attributes['geolong']
        self.distance     = attributes['distance']
      end
    end
                    
    def self.find(*args)
      options = extract_options(args)
      case args.first
        when :all   then find_all(options)
        when :first then find_first(options)
      end
    end
    
    private
           
    def self.find_all(options)
      if options[:near]
        latlng = GeoKit::LatLng.normalize(options.delete(:near))
        options[:geolat] = latlng.lat
        options[:geolong] = latlng.lng
      else
        options[:geolat]  ||= latitude
        options[:geolong] ||= longitude
      end
      options[:l] ||= options.delete(:limit)  if options[:limit]
      options[:q] ||= options.delete(:search) if options[:search]
      options[:r] ||= options.delete(:radius) if options[:radius]
      
      response = get("/venues.json", :query => options)
      response["venues"]["group"].map do |venue_hash|
        new(venue_hash)
      end
    end
    
    def self.find_first(options)
      find_all(options.merge(:limit => 1)).first
    end
  end
end