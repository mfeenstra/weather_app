json.extract! location, :id, :zipcode, :street, :city, :country_code, :lat, :long, :created_at, :updated_at
json.url location_url(location, format: :json)
