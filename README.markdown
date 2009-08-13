Foursquare
==========

A ruby interface for Foursquare's JSON [API Documentation](http://groups.google.com/group/foursquare-api/web/api-documentation).
Sign up for a Foursquare account at [http://playfoursquare.com](http://playfoursquare.com).

Install
-------

    $ gem sources -a http://gems.github.com
    $ sudo gem install cmdrkeene-foursquare

Usage
-----

### **checkin** - Allows you to check-in to a place.

First, create a new Foursquare instance with your Basic Authentication
credentials:

    @foursquare = Foursquare.new("user@example.com", "sekret")

Then, you can check in with a venue id (vid):

    @foursquare.checkin(:vid => 1234)
    
Or you can check in with a name search for a venue:

    @foursquare.checkin(:venue => "Mamoun's")

If successful, you will get a response hash with the following keys:

*    **ID**

        "id" => 701707

*    **Message**

        "message" => "OK! We've got you @ Santana's Bay Park."

*    **Created**

        "created" => "Tue, 11 Aug 09 16:02:13 +0000"


*    **Mayor**

        "mayor" => {
          "type"    => "nochange",
          "message" => "Casey W. is The Mayor of Santana's Bay Park."
        }

*    **Scoring**

        "scoring" => {
          "score" => {
            "icon"    => "http://playfoursquare.com/images/scoring/2.png",
            "points"  => 1,
            "message" => "First stop today"
          },
          "total" => {
            "points"  => 6,
            "message" => "6 pts "
          },
          "rank" => {
            "city" => {
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

*    **Badges**

        "badges" => {
          "badge" => {
            "name"  => "Newbie",
            "text"  => "Congrats on your first check-in!",
            "icon"  => "http://playfoursquare.com/images/badges/newbie_on.png",
            "id"    => 54494
          }
        }

*    **Venue**
    
        "venue" => {
          "city"        => "San Diego",
          "address"     => "1975 Morena Blvd.",
          "name"        => "Santana's Bay Park",
          "zip"         => 92110, 
          "geolong"     => -117.207,
          "geolat"      => 32.782, 
          "crossstreet" => nil,
          "id"          => 84689,
          "cityid"      => 38,
          "state"       => "CA"
        }