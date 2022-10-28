class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show edit update destroy refresh ]

  # GET /locations or /locations.json
  def index
    @locations = Location.all
  end

  # GET /locations/1 or /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
    # @location.weather_now
    # @location.weather_forecast end
  end

  def refresh
    @location = Location.find(params[:id])
    @location.weather_now
    @location.weather_forecast

    redirect_to @location
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations or /locations.json
  def create

    # creating a new Location from user input (submit form, location_params)

    # 1. look up all weather data for that location
    #    - using zipcode as specific enough (non-unique index) for fetching metrics
    #    - looks for cached metrics, from within 30 minutes, first
    #    - if none existing, then do api call to:
    #      a.  ForecastByZip.perform(zip, county) for Future periods (40 usually, 16 days?)
    #      b.  WeatherByLocation
    #      a. parse into metric hash(es) from 

    # @location = Location.new(location_params)
    @location = Location.create!(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to location_url(@location), notice: "Location was successfully created." }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1 or /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to location_url(@location), notice: "Location was successfully updated." }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1 or /locations/1.json
  def destroy
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url, notice: "Location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.require(:location).permit(:zipcode, :street, :city, :country_code, :lat, :long)
    end
end
