# A simple http request method with retry interval.

require 'net/http'

module CallApi

  def self.perform(uri_string)
    attempt = 0
    while attempt < 3
      begin
        attempt += 1
        uri = URI.parse(uri_string)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(request)
        end
        response_code = response.code.to_i
        puts "http [#{response_code}]"
        break
      rescue StandardError => e
        response_code = response.code.to_i
        puts "http [#{response_code}]"
        puts "CallAPI Error: Attempt #{attempt} of 3: #{e.full_message}"
        sleep 3
      end
    end
    JSON.parse(response.body)
  end

end

