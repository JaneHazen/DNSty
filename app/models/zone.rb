require 'net/http'
require 'uri'
require 'json'

class Zone < ApplicationRecord

  def self.create_zone(new_zone)
    p "$" * 100
    uri = URI.parse("https://api.nsone.net/v1/zones/newzone.com")
    request = Net::HTTP::Put.new(uri)
    request["X-Nsone-Key"] = "#{ENV['API_KEY']}"
    request.body = JSON.dump({
    "zone" => "#{new_zone}",
    "nx_ttl" => 60
    })

    req_options = {
    use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end



end
