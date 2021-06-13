class Department < ApplicationRecord
  has_many :user
  has_many :offer
  has_many :api_offer
end
