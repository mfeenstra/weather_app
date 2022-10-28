
# GeoByZip.perform('90210', 'us')
#
# URI: http://api.openweathermap.org/geo/1.0/zip?appid=fddf2e0b34696ad4d38b118897058f7c&zip=90210%2Cus
# http [200]
#
#  => {"zip"=>"90210", "name"=>"Beverly Hills", "lat"=>34.0901, "lon"=>-118.4065, "country"=>"US"} 

module GeoByZip

  def self.perform(zip = '', country = '')
    query = { zip: "#{zip},#{country}",
              appid: Rails.application.credentials.openweather[:api_key] }
    uri_string = "#{CFG.geo_zip_url}?#{query.to_query}"
    CallApi.perform(uri_string)
  end

end
