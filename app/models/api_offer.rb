class ApiOffer < ApplicationRecord
  has_many :api_offer_department
  has_many :department, through: :api_offer_department
end
