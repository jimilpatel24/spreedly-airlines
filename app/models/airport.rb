class Airport < ApplicationRecord
    has_many :departures, class_name: 'Flight', foreign_key: :departure_airport_id, dependent: :destroy
    has_many :arrivals, class_name: 'Flight', foreign_key: :arrival_airport_id, dependent: :destroy
  
    def name_with_code
      "#{name} (#{code})"
    end
  end