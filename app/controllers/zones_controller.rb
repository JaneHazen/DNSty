require 'net/http'
require 'uri'
require 'json'


class ZonesController < ApplicationController
  before_action :set_zone, only: [:show]

  def index
    @json = JSON(get_active_nsone_zones.body)
    @zones = Zone.all

  end

  def show
    @zone = Zone.find(params[:id])
  end

  def new
    @zone = Zone.new
  end

  def edit
  end

  def create
    @zone = Zone.new(zone: params["zone"])
    test = create_nsone_zone(params["zone"])
    test

    respond_to do |format|
      if @zone.save
        format.html { redirect_to @zone, notice: 'Zone was successfully created.' }
        format.json { render :show, status: :created, location: @zone }
      else
        format.html { render :new }
        format.json { render json: @zone.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def set_zone
      @zone = Zone.find(params[:id])
    end

    def create_nsone_zone(new_zone)
     uri = URI.parse("https://api.nsone.net/v1/zones/#{new_zone}.com")
      request = Net::HTTP::Put.new(uri)
      request["X-Nsone-Key"] = "#{ENV['API_KEY']}"
      request.body = JSON.dump({
        "zone" => "#{new_zone}.com",
        "ttl" => 3600,
        "nx_ttl" => 60
      })

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
    end

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
