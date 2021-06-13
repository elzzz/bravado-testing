class ApiOffer < ApplicationRecord
  has_many :api_offer_departments
  has_many :departments, through: :api_offer_departments
end
