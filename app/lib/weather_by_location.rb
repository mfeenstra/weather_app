# WeatherByLocation provides the weather information for Today in a given city and country
#
# Example usage (raw result):
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

module WeatherByLocation

  # runs the API call to OpenWeathermap API
  # returns: Hash of data from the site
  def self.perform(city, country)
    query = { q: "#{city},#{country}",
              units: CFG.temperature_units,
              appid: Rails.application.credentials.openweather[:api_key] }
    uri_string = "#{CFG.weather_url}?#{query.to_query}"
    CallApi.perform(uri_string)
  end

  # runs the above API call and transforms the data to be like our Metric model.
  # intended to be ran from the "weather_now" method in the Location model.
  def self.metric(city, country)
    logger = Logger.new(STDOUT)
    data = self.perform(city, country)
    unless (data['cod'].to_i >= 400) && (data['cod'].to_i < 500)
      # location_id & zipcode ->  set by the calling Location model object.. what's left are:
      #   temp, min, max, day ( day is 0 for today, or current weather )
      return { temp:   data['main']['temp'],
               min:    data['main']['temp_min'],
               max:    data['main']['temp_max'],
               period: 0,
               dt_txt: Time.at(data['dt']).utc }
    end
    logger.error "bad api result: #{data}"
    {}
  end

end
