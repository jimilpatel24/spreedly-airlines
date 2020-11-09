class FlightsController < ApplicationController
    def index
      @flight = Flight.new
      @flights = Flight.none
    end
  
    def search
      @flight = Flight.new(search_params)
      @flights = Flight.where(departure_airport_id: params[:flight][:departure_airport_id], arrival_airport_id: params[:flight][:arrival_airport_id], takeoff: Date.parse(params[:flight][:takeoff]).all_day)
      if @flights.empty?
        flash.now.alert = 'No flights found'
        render 'index'
        return
      end
  
      render 'index'
    end
  
    def show
      @flight = Flight.find(params[:id])
    end
  
    def new
      @flight = Flight.new
    end
  
    def search_params
      params.require(:flight).permit(:departure_airport_id, :arrival_airport_id, :takeoff)
    end
  end
  