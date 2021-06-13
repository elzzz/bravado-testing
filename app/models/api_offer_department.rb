class ApiOfferDepartment < ApplicationRecord
  belongs_to :api_offer
  belongs_to :department
end
