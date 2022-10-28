# ForecastByZip provides the Extended 5-day forecast in 3 hour increments
#
# Example usage:
#
# f = ForecastByZip.perform('92260', 'us')

module ForecastByZip

  # builds up the API query and runs the http call
  # returns: Hash result
  def self.perform(zipcode, country)

    query = { zip: "#{zipcode},#{country}",
              units: CFG.temperature_units,
              appid: Rails.application.credentials.openweather[:api_key] }

    uri_string = "#{CFG.forecast_url}?#{query.to_query}"
    CallApi.perform(uri_string)
  end

  # metrics takes the API result and transforms it to be like our Metric model
  # returns: Hash
  def self.metrics(zipcode, country)
    logger = Logger.new(STDERR)
    forecast = []

    begin
      logger.debug "ForecastByZip(#{zipcode}, #{country})"
      list = self.perform(zipcode, country)['list']
    rescue => e
      logger.error "ERROR: problem with values passed to API, zipcode: <#{zipcode}>, " \
                   "country_code: <#{country}> =>\n#{e.full_message}"
      return [ { temp: 'n/a',
                 min: 'n/a',
                 max: 'n/a',
                 period: 'n/a',
                 dt_txt: 'n/a' } ]
    end
             
    unless list.nil?
      list.each.with_index(1) do |period, i|
         forecast << { temp: period['main']['temp'],
                       min:  period['main']['temp_min'],
                       max:  period['main']['temp_max'],
                       period: i, # values should come in chronological order
                       dt_txt: Time.parse(period['dt_txt']).utc # date&time each 3 hour period
                     }
      end
    else
      logger.error "could not get the forecast! (#{zipcode}, #{country})"
    end

    forecast
  end

end
