module Foursquare
  class User < Base
    # Returns data for a particular user
    #
    # Options
    #   :uid    => userid for the user whose information you want to retrieve. 
    #              if you do not specify a 'uid', the authenticated user's 
    #              profile data will be returned.
    #   :badges => (optional, default: false) set to true ("1") to also show 
    #              badges for this user
    #   :mayor  => (optional, default: false) set to true ("1") to also show 
    #              venues for which this user is a mayor
    def self.find(options = {}) 
      get("/user.json", :query => options)["user"]
    end
  end
end