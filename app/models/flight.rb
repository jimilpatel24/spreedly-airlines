class Flight < ApplicationRecord
    include FlightsHelper
    belongs_to :arrival_airport, class_name: 'Airport'
    belongs_to :departure_airport, class_name: 'Airport'
    has_many :bookings
    has_many :passengers, through: :bookings, source: :user
  end
  