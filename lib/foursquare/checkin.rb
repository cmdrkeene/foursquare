module Foursquare 
  class Checkin < Base
    def self.attribute_names
      [:id,
       :message,
       :created_at,
       :badges,
       :mayor,
       :scoring,
       :venue
      ]
    end
    
    attr_accessor *attribute_names

    def initialize(attributes = nil)
      if attributes
        self.id         = attributes['id']
        self.message    = attributes['message']
        self.created_at = Time.parse(attributes['created'])
        self.badges     = [attributes['badges']['badge']]
        self.mayor      = attributes['mayor']
        self.scoring    = attributes['scoring']
        self.venue      = Venue.new(attributes['venue'])
      end
    end
    
    # Allows you to check-in to a place.
    #
    # Options
    #   :vid      => (optional, not necessary if you are 'shouting' or have a
    #                venue name). ID of the venue where you want to check-in.
    #   :venue    => (optional, not necessary if you are 'shouting' or have a
    #                vid) if you don't have a venue ID, pass the venue name as
    #                a string using this parameter. foursquare will attempt to
    #                match it on the server-side
    #   :shout    => (optional) a message about your check-in
    #   :private  => (optional, defaults to the user's setting). true means
    #                "don't show your friends". false means "show everyone"
    #   :twitter  => (optional, defaults to the user's setting). false means
    #                "send to twitter". false means "don't send to twitter"
    #   :geolat   => (optional, but recommended)
    #   :geolong  => (optional, but recommended)
    def self.create(options = {})
      unless options[:private].nil?
        options[:private] = options[:private] ? 1 : 0
      end
      unless options[:twitter].nil?
        options[:twitter] = (options[:twitter] ? 1 : 0)
      end
      response = post "/checkin.json",
                      :query      => options,
                      :basic_auth => authentication
      raise RecordNotFound if response.keys.include?("addvenueprompt")
      new(response["checkin"])
    end
  end
end