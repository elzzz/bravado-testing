class Offer < ApplicationRecord

  has_many :offer_department
  has_many :department, through: :offer_department

  scope :by_company_icontains, -> (company_name) { where("company ILIKE :search", search: "%#{company_name}%") }
  scope :by_departments_ids, -> (department_ids) { where(offer_departments: { department_id: department_ids }) }
  scope :by_price_sort, -> (sort_type) { order(price: sort_type) }

  def self.per_page
    30
  end
end
