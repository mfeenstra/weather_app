class Metric < ApplicationRecord
  belongs_to :location

  # returns: True if time since last update is greater than CFG.cache_minutes=30, from Rails.root/config/weather_app.yml
  def is_stale?
    ((Time.now - self.updated_at) / 60.0) > CFG.cache_minutes.to_f
  end

end
