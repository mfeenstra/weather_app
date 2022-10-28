

# pp GeoByLocation.perform('sacramento', 'ca', 'usa')
#
# URI: http://api.openweathermap.org/geo/1.0/direct?appid=fddf2e0b34696ad4d38b118897058f7c&limit=5&q=sacramento%2Cca%2Cusa
# http [200]
#
# [{"name"=>"Sacramento",                      
#   "local_names"=>                            
#    {"ar"=>"ساكرامنتو",                       
#     "lt"=>"Sakramentas",                     
#     "pl"=>"Sacramento",                      
#     "en"=>"Sacramento",                      
#     "ta"=>"சேக்ரமெண்டோ",                       
#     "zh"=>"沙加緬度/萨克拉门托",             
#     "uk"=>"Сакраменто",                      
#     "ja"=>"サクラメント",                    
#     "ru"=>"Сакраменто"},                     
#   "lat"=>38.5810606,                         
#   "lon"=>-121.493895,
#   "country"=>"US",
#   "state"=>"California"},
#  {"name"=>"Sacramento", "lat"=>36.5323267, "lon"=>-6.2995343, "country"=>"ES", "state"=>"Andalusia"}]

module GeoByLocation

  def self.perform(city = '', state = '', country = '', limit = 5)
    query = { q: "#{city},#{state},#{country}",
              limit: limit,
              appid: Rails.application.credentials.openweather[:api_key] }
    uri_string = "#{CFG.geo_url}?#{query.to_query}"
    CallApi.perform(uri_string)
  end

end
