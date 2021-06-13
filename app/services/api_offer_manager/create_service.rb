module ApiOfferManager
  class CreateService < ApplicationService
    def initialize(id:, company:, price:)
      @id = id
      @company = company
      @price = price
    end

    def call
      ApiOffer.create(
        id: @id,
        company: @company,
        price: @price
      )
    end
  end
end
