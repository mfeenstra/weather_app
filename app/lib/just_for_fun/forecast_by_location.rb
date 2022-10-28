# Example usage:
#
# f = ForecastByLocation.perform('sacramento', 'us')
#
# URI: http://api.openweathermap.org/data/2.5/weather?appid=fddf2e0b34696ad4d38b118897058f7c&q=sacramento%2Cus&units=imperial
# http [200]
#
# f =
#
# {"coord"=>{"lon"=>-121.3177, "lat"=>38.4666},
#  "weather"=>[{"id"=>800, "main"=>"Clear", "description"=>"clear sky", "icon"=>"01d"}],
#  "base"=>"stations",                         
#  "main"=>                                    
#   {"temp"=>73.92, "feels_like"=>72.61, "temp_min"=>70.79, "temp_max"=>75.96, "pressure"=>1018, "humidity"=>34},
#  "visibility"=>10000,                        
#  "wind"=>{"speed"=>6.91, "deg"=>260},        
#  "clouds"=>{"all"=>0},                       
#  "dt"=>1666738185,                           
#  "sys"=>{"type"=>2, "id"=>2002655, "country"=>"US", "sunrise"=>1666707860, "sunset"=>1666746843},
#  "timezone"=>-25200,                         
#  "id"=>5389519,                              
#  "name"=>"Sacramento",                       
#  "cod"=>200}

module ForecastByLocation

  def self.perform(city, country)
    query = { q: "#{city},#{country}",
              units: CFG.temperature_units,
              appid: Rails.application.credentials.openweather[:api_key] }
    uri_string = "#{CFG.weather_url}?#{query.to_query}"
    CallApi.perform(uri_string)
  end

end
