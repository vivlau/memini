require "json"
require "http"
require "optparse"

YELP_CLIENT_ID = ENV['YELP_CLIENT_ID']
YELP_CLIENT_SECRET = ENV['YELP_CLIENT_SECRET']

# Constants, do not change these
API_HOST = "https://api.yelp.com"
SEARCH_PATH = "/v3/businesses/search"
BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
TOKEN_PATH = "/oauth2/token"
GRANT_TYPE = "client_credentials"

DEFAULT_BUSINESS_ID = "yelp-san-francisco"
DEFAULT_TERM = "dinner"
DEFAULT_LOCATION = "San Francisco, CA"
SEARCH_LIMIT = 5

class SchedulesController < ApplicationController
  def index
  end

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new schedule_params
    @schedule.user = current_user
    @schedule.save
    save_data_from_yelp_api
  end

  def show
    @event = Event.new
  end

  def make_google_calendar_reservations
    @schedule = @cohort.schedules.find_by(slug:
      params[:slug])
    @calendar = GoogleCalWrapper.new(current_user)
    @calendar.book_rooms(@schedule)
  end

  def bearer_token
		# Put the url together
		url = "#{API_HOST}#{TOKEN_PATH}"

		raise "Please set your YELP_CLIENT_ID" if YELP_CLIENT_ID.nil?
		raise "Please set your YELP_CLIENT_SECRET" if YELP_CLIENT_SECRET.nil?

		# Build our params hash
		params = {
			client_id: YELP_CLIENT_ID,
			client_secret: YELP_CLIENT_SECRET,
			grant_type: GRANT_TYPE
		}

		response = HTTP.post(url, params: params)
		parsed = response.parse

		"#{parsed['token_type']} #{parsed['access_token']}"
	end

  def search(term, location, limit)
    url = "#{API_HOST}#{SEARCH_PATH}"

    params = {
      term: term,
      location: location,
      limit: limit
    }

    response = HTTP.auth(bearer_token).get(url, params: params)
    response.parse
  end

  def business(business_id)
    url = "#{API_HOST}#{BUSINESS_PATH}#{business_id}"

    response = HTTP.auth(bearer_token).get(url)
    response.parse
  end

	def save_data_from_yelp_api
    last_datetime = DateTime.parse(@schedule.return_date + " " +@schedule.return_time)
    first_datetime = DateTime.parse(@schedule.departure_date + " " + @schedule.departure_time)
    limit = (last_datetime - first_datetime).to_i
    first_day = DateTime.parse(@schedule.departure_date).to_date
    last_day = DateTime.parse(@schedule.return_date).to_date
    location = @schedule.location
    term = ["Breakfast", "Lunch", "Dinner"]

    term.each do |t|
      searching = search(t, location, limit)
      i = 0
      while (i < limit)
        searching['businesses'].each do |b|
          e = Event.new
          event_day = first_day + i
          e.start_date = event_day
          e.end_date = event_day
          day_of_week = event_day.cwday-1
          details = business(b['id'])
          if t == "Breakfast" && details['hours'].present?
            e.start_time = DateTime.parse(event_day.to_s + " " + (details['hours'][0]['open'][day_of_week]['start'])).strftime("%H:%M")
            e.end_time = (DateTime.parse(event_day.to_s + " " + (details['hours'][0]['open'][day_of_week]['start'])) + 90.minutes).strftime("%H:%M")
          elsif t == "Breakfast"
            e.start_time = DateTime.parse("9:00am").strftime("%H:%M")
            e.end_time = (DateTime.parse("9:00am") + 90.minutes).strftime("%H:%M")
          elsif t == "Lunch"
            e.start_time = DateTime.parse("12:00pm").strftime("%H:%M")
            e.end_time = (DateTime.parse("12:00pm") + 2.hours).strftime("%H:%M")
          elsif t == "Dinner"
            e.start_time = DateTime.parse("6:00pm").strftime("%H:%M")
            e.end_time = (DateTime.parse("6:00pm") + 2.hours).strftime("%H:%M")
          elsif t == "Bar"
            e.start_time = DateTime.parse("9:00pm").strftime("%H:%M")
            e.end_time = (DateTime.parse("9:00pm") + 2.hours).strftime("%H:%M")
          end
          e.categories = b['categories']
          e.search_term = t
          e.name = b['name']
          e.event_name = e.search_term + " at " + e.name
          e.reviews = b['review_count']
          e.description = details['snippet_text']
          e.rating = b['rating']
          e.coordinates = (b['coordinates']['latitude']).to_s + ", " + (b['coordinates']['longitude']).to_s
          e.address = (b['location']['display_address'][0]).to_s + ", " + (b['location']['display_address'][1]).to_s + ", " + (b['location']['display_address'][2]).to_s
          e.event_location = e.address
          e.phone = b['display_phone']
          e.price = b['price']
          e.images = details['photos']
          e.hours = details['hours'][0]['open']
          e.user = current_user
          e.schedule_id = @schedule.id
          e.save
          puts "#{e.errors.full_messages}"
          i += 1
          sleep(3)
        end
      end
    end
	end

  private

  def schedule_params
    params.require(:schedule).permit(:location, :departure_date, :departure_time, :return_date, :return_time, traveller_type:[])
  end
end
