# A Ruby API for Foursquare (playfoursquare.com)

This is a thin interface to Foursquare's JSON API. You can find full documents
here: http://groups.google.com/group/foursquare-api/web/api-documentation

## Actions

*   **checkin** - check into a venue
*   **cities** - listing of active cities
*   **venues** - search for venues
 
## Usage

### checkin

This is how you check into a venue:

    @foursquare = Foursquare.new("user@example.com", "sekret")
    @foursquare.checkin(:vid => 1234)         # => A specific venue id
    @foursquare.checkin(:venue => "Mamoun's") # => A name search for venue

If successful, you will get a response hash with the following keys:

#### ID

    "id" => 701707

#### Message

    "message" => "OK! We've got you @ Santana's Bay Park."

#### Created

    "created" => "Tue, 11 Aug 09 16:02:13 +0000"


#### Mayor

    "mayor" => {
      "type"    => "nochange",
      "message" => "Casey W. is The Mayor of Santana's Bay Park."
    }

#### Scoring

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

#### Badges

    "badges" => {
      "badge" => {
        "name"  => "Newbie",
        "text"  => "Congrats on your first check-in!",
        "icon"  => "http://playfoursquare.com/images/badges/newbie_on.png",
        "id"    => 54494
      }
    }

#### Venue
    
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
    
### cities