class Offer < ApplicationRecord
  attr_accessor :label
  has_many :offer_departments
  has_many :departments, through: :offer_departments

  #noinspection SpellCheckingInspection
  scope :by_company_icontains, lambda { |company_name| where("company LIKE :search", search: "%#{company_name}%") }
  scope :by_departments_ids, lambda { |department_ids| where(departments: { id: department_ids }) }
  scope :by_price_sort, lambda { |sort_type| order(price: sort_type) }

  serialize :label

  def self.serialization_fields
    [:id, :price, :company, :label]
  end

  def self.per_page
    30
  end
end
