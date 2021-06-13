class User < ApplicationRecord
  has_many :user_department
  has_many :department, through: :user_department
end
