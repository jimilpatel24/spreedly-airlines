require 'httparty'

class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flight
  accepts_nested_attributes_for :user
end
