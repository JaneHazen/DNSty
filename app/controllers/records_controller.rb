require 'net/http'
require 'uri'
require 'json'

class RecordsController < ApplicationController
  before_action :set_record, only: [:show]

  def index
    @records = Record.all
  end

  def show
  end

  def new
    @record = Record.new
  end

  def create
    @thiszone = Zone.find(params["zone_id"])
    @record = Record.new(zone_id: params["zone_id"], id: params["id"], name: params["record"]["name"])

    test = create_nsone_record(zone: @thiszone.zone, record: @record.name)
    test
    p test.body

    respond_to do |format|
      if @record.save
        format.html { render :show, notice: 'Record was successfully created.' }
        format.json { render :show, status: :created, location: @zone }
      else
        p @record.errors.full_messages
        format.html { redirect_to zone_path(@thiszone.id) }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def set_record
      @record = Record.find(params[:id])
    end

    def create_nsone_record(params)
      uri = URI.parse("https://api.nsone.net/v1/zones/#{params[:zone]}.com/#{params[:record]}.#{params[:zone]}.com/A")
      request = Net::HTTP::Put.new(uri)
      request["X-Nsone-Key"] = "#{ENV['API_KEY']}"
      request.body = JSON.dump({
        "zone" => "#{params[:zone]}.com",
        "domain" => "#{params[:record]}.#{params[:zone]}.com",
        "type" => "A",
        "answers" => [
          {
            "answer" => ["1.2.3.4"]
          }
        ]
      })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
    end
end
