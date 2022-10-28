### LocationByGeo provides information for the locale nearest the given geogrpahical coordinates
#
# Example usage:
#
# p LocationByGeo.perform('51.5098', '-0.1180')
#
# URI: http://api.openweathermap.org/geo/1.0/reverse?appid=fddf2e0b34696ad4d38b118897058f7c&lat=51.5098&limit=5&lon=-0.1180
#
# [{"name"=>"City of Westminster",                               
#   "local_names"=>                                              
#    {"ru"=>"Вестминстер",                                       
#     "fr"=>"Cité de Westminster",                               
#     "cy"=>"San Steffan",                                       
#     "ko"=>"시티오브웨스트민스터",                              
#     "he"=>"וסטמינסטר",                                         
#     "en"=>"City of Westminster",                               
#     "mk"=>"Град Вестминстер",                                  
#     "be"=>"Вэстмінстэр"},                                      
#   "lat"=>51.4973206,                                           
#   "lon"=>-0.137149,                                            
#   "country"=>"GB",
#   "state"=>"England"}]

module LocationByGeo

  def self.perform(latitude = '', longitude = '', limit = 5)
    query = { lat: latitude,
              lon: longitude,
              limit: limit,
              appid: Rails.application.credentials.openweather[:api_key] }
    uri_string = "#{CFG.loc_geo_url}?#{query.to_query}"
    CallApi.perform(uri_string)
  end

end
