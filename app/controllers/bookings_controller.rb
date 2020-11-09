class BookingsController < ApplicationController
  def new
    @flight = Flight.where(id: params[:flight]).includes(:departure_airport, :arrival_airport).first
    @booking = @flight.bookings.build
    @passengers = []
    params[:passengers].to_i.times { @passengers << @flight.passengers.build }
  end

  def index
    @bookings = Booking.find(params[:bookings])
  end

  def create
    @flight = Flight.find(params[:booking][:flight_id])
    token = params[:payment_method_token]
    total_passengers = params[:passengers].to_i
    total_amount = params[:amount].to_i
    amount = total_amount/total_passengers

    @bookings = []
    params[:passenger].each do | passenger |
      @user = @flight.passengers.build(name: passenger[:name], email: passenger[:email])
      next unless @user.save

      @booking = @flight.bookings.build(user_id: @user.id, purchased_amount: amount)
      @bookings << @booking
    end
    if @bookings.each(&:save)
      @bookings.each do |booking|
        @user = booking.user
      end
      if params[:booking][:expedia]
        expedia_success = buy_expedia(token, total_amount)
        if expedia_success && expedia_success['transaction']['succeeded'] == true
          redirect_to bookings_path(bookings: @bookings), notice: "Expedia received your reservation."
        else
          redirect_to '/bookings/new?flight='+@flight.id.to_s+'&passengers='+params[:passenger].length().to_s+'&commit=Purchase+tickets', alert: "Payment method declined"
        end
      else
        buy_success = buy_gateway(token, total_amount)
        if buy_success && buy_success['transaction']['succeeded'] == false
          redirect_to '/bookings/new?flight='+@flight.id.to_s+'&passengers='+params[:passenger].length().to_s+'&commit=Purchase+tickets', alert: "Payment method declined"
        end
        redirect_to bookings_path(bookings: @bookings)
      end
      return
    end

    fail
  end

  def show
    @booking = Booking.where(id: params[:id]).includes( { flight: [:departure_airport, :arrival_airport] }, :user).first
  end


  def booking_params
    params.require(:booking).permit(:flight_id)
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def buy_gateway(token, amount)
    base_uri = 'https://core.spreedly.com/v1/gateways/'
    buy_uri = base_uri + ENV['gateway_token']+'/purchase.json'

    options = {
        headers: {'Content-Type' => 'application/json'},
        basic_auth: {
            "username": ENV['spreedly_env_key'],
            "password": ENV['spreedly_secret']
        },
        body: {
            "transaction": {
                "payment_method_token": token,
                "amount": amount,
                "currency_code": "USD",
                "retain_on_success": true
            }
        }.to_json
    }
    
    response = HTTParty.post(buy_uri, options)
    puts response.parsed_response
    response.parsed_response 
  end

  def buy_expedia(token, amount)
    base_uri = 'https://core.spreedly.com/v1/receivers/'
    buy_uri = base_uri + ENV['pmd_token']+'/deliver.json'

    options = {
        headers: {'Content-Type' => 'application/json'},
        basic_auth: {
            "username": ENV['spreedly_env_key'],
            "password": ENV['spreedly_secret']
        },
        body: {
          "delivery": {
              "payment_method_token": token,
              "url": "https://postman-echo.com/post",
              "headers": "Content-Type: application/json",
              "body": "{ \"flight_id\": \"params[:booking][:flight_id]\",\"amount\": amount}"
            }
        }.to_json
    }
    
    response = HTTParty.post(buy_uri, options)
    puts response.parsed_response
    response.parsed_response             
  end
end
