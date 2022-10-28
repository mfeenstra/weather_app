class Location < ApplicationRecord

  has_many :metric, dependent: :delete_all
  accepts_nested_attributes_for :metric, allow_destroy: true
  validates :city, :zipcode, :country_code, presence: true

  # returns: hash (PoR) for current weather
  def now
    n = Metric.where(location_id: id, period: 0)
    n.map(&:attributes).first
  end

  # returns: array (PoR) of (metric model) hashes (future weather periods)
  def future
    f = Metric.where(location_id: id, period: (1..))
    f.map(&:attributes)
  end

  def is_cached?
    self.now['from_cache'] == true ? true : false
  end

  ### download data ###

  # weather_now gets the singular, current (period=0), weather metric
  def weather_now

    # A weather metric is either 1] existing and new (cached) 2] old (stale, remove) or,
    #   3] non-existant (api download)
    # so, pull each metric that may be for this zipcode -- use if new, remove if stale, pull if blank
    my_params = { location_id: self.id, zipcode: self.zipcode, period: 0 }

    # when current metric exists for this location, check if it's stale, then flag it as good for cache
    if Metric.exists?(my_params)
      metrics = Metric.where(my_params)
      logger.info "Location.weather_now: Found #{metrics.size} existing metrics for location: " \
                  "#{self.id} and zipcode: #{self.zipcode}"
      red = 0; green = 0
      metrics.each { |m| m.is_stale? ? (m.destroy! && red += 1) : (m.update!(from_cache: true) && green += 1) }
      logger.info "Location.weather_now: Destroyed #{red} stale records, and saving #{green} metrics as cache."
    end

    # if we have one in there that is cache, use it, otherwise build a brand new metric
    new_params = my_params.merge(from_cache: true)
    unless Metric.exists?(new_params)
      logger.info "Location.weather_now: No existing metric records found, calling API for fresh data .."
      metric_data = WeatherByLocation.metric(self.city, self.country_code)
      metric_data['zipcode'] = self.zipcode
      metric_data['location_id'] = self.id
      Metric.create!(metric_data)
    else
      metric_data = Metric.where(new_params)
    end
  end

  # weather_forcast gets a list of forward-looking (period=1+n) weather metrics, one for each period
  def weather_forecast
    forecast = ForecastByZip.metrics(self.zipcode, self.country_code)
    metrics_data = []
    forecast.each do |p|
      period_element = p.merge(zipcode: self.zipcode, location_id: self.id)
      metrics_data << period_element
    end
    i = 0
    metrics_data.each do |m|
      Metric.create!(m)
      i += 1
    end
    logger.info "Recorded #{i} forecast periods for Location #{self.id}, #{self.zipcode}"
  end

end
