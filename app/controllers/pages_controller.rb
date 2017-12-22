class PagesController < ApplicationController
  def home
    @zones = JSON(get_active_nsone_zones.body)
  end

  private

  def get_active_nsone_zones

      uri = URI.parse("https://api.nsone.net/v1/zones")
      request = Net::HTTP::Get.new(uri)
      request["X-Nsone-Key"] = "#{ENV['API_KEY']}"

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
    end
end
