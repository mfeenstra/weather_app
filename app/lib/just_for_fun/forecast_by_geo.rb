# ForecastByGeo provides the 5-day / 3 hour forecast for a given geographical coordinate
#
# Example usage:
#
# f = ForecastByGeo.perform('44.34', '10.99')

module ForecastByGeo

  def self.perform(latitude, longitude)
    query = { lat: latitude,
              lon: longitude,
              units: CFG.temperature_units,
              appid: Rails.application.credentials.openweather[:api_key] }
    uri_string = "#{CFG.forecast_url}?#{query.to_query}"
    CallApi.perform(uri_string)
  end

end
