module ApiOfferDepartmentManager
  class CreateService < ApplicationService
    def initialize(api_offer, department)
      @api_offer = api_offer
      @department = department
    end

    def call
      ApiOfferDepartment.create(
        api_offer_id: @api_offer.id,
        department_id: @department.id
      )
    end
  end
end