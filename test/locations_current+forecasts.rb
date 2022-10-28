#!/usr/bin/env ruby
require_relative "../config/environment"
# fixtures
locations = [

{ street: '888 sesame street', city: 'sacramento',  country_code: 'us', zipcode: '95660', lat: '', long: '' },
{ street: '12345 port st', city: 'london',  country_code: 'gb', zipcode: 'E1 7AW', lat: '', long: '' },
{ street: '999 imperial pkwy', city: 'london',  country_code: 'gb', zipcode: 'E1 7BH', lat: '', long: '' },
{ street: '983 friends rd', city: 'beverly hills',  country_code: 'us', zipcode: '90210', lat: '', long: '' },
{ street: 'XYZ garbage st.', city: 'bad_town', country_code: 'ZED', zipcode: 'z3dz d3d', lat: 'abc', long: 1 },
{ street: '777 el paseo', city: 'palm desert',  country_code: 'us', zipcode: '92260', lat: '', long: '' },
{ street: '956 main wy', city: 'los angeles',  country_code: 'us', zipcode: '90001', lat: '', long: '' },
{ street: '567 apline rd', city: 'banff', country_code: 'ca', zipcode: 'T1L 1A7', lat: '', long: '' } ]

# clean out the old fixtures if they exist
locations.each do |l|
  search_it = { city: l[:city], country_code: l[:country_code], zipcode: l[:zipcode] }

  # clean out the old fixtures if they exists.. note, weather metrics are dependent and are also destroyed
  if Location.where(search_it).any?
    Location.find_by(search_it).destroy!
    print 'x'
  end

  new_loc = Location.create!(l)
  new_loc.weather_now
  new_loc.weather_forecast
  print '.'
end
