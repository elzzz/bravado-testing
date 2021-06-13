module Bravado
  class ApiOffer
    def initialize(api_offer_data)
      @api_offer_data = api_offer_data
    end

    def id
      @api_offer_data.fetch('id')
    end

    def company
      (@api_offer_data.fetch('requestor_company') || {}).fetch('name', nil)
    end

    def price
      @api_offer_data.fetch('price')
    end

    def departments
      @api_offer_data.fetch('departments', []).map { |department| department.fetch('name', '') }
    end
  end
end