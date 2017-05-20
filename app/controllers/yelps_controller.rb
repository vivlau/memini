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

class YelpsController < ApplicationController
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

  def search(term, location)
    url = "#{API_HOST}#{SEARCH_PATH}"
    params = {
      term: term,
      location: 'Vancouver, BC',
      limit: 50
    }

    response = HTTP.auth(bearer_token).get(url, params: params)
    response.parse
  end

  def business(business_id)
    url = "#{API_HOST}#{BUSINESS_PATH}#{business_id}"

    response = HTTP.auth(bearer_token).get(url)
    response.parse
  end

	def show
		@restaurant = search("Brunch", location)
    business_id = @restaurant['businesses'][0]['id']
    @business = business(business_id)

		@results = {
			:restaurant => @restaurant,
      :business => @business
		}

		render json: @results
	end
end
