module ApiOfferManager
  class Create < ApplicationService
    def initialize(api_offer_object)
      @api_offer_object = api_offer_object
    end

    def call
      api_offer = ApiOffer.create(
        id: @api_offer_object.id,
        company: @api_offer_object.company,
        price: @api_offer_object.price
      )

      @api_offer_object.departments.each do |name|
        department = Department.find_by_name(name)
        ApiOfferDepartment.create(api_offer_id: api_offer.id, department_id: department.id) if department
      end
    end
  end
end
