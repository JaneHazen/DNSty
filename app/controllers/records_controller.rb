require 'net/http'
require 'uri'
require 'json'

class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]

  # GET /records
  # GET /records.json
  def index
    @records = Record.all
  end

  # GET /records/1
  # GET /records/1.json
  def show
  end

  # GET /records/new
  def new
    @record = Record.new
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records
  # POST /records.json
  def create
    p "$"* 100
    p params
    @thiszone = Zone.find(params["zone_id"])
    @record = Record.new(zone_id: params["zone_id"], id: params["id"], name: params["record"]["name"])

    test = create_nsone_record(zone: @thiszone.zone, record: @record.name)
    test
    p test.body
    p "YES" * 100


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

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to @record, notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @record }
      else
        format.html { render :edit }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to records_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
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
