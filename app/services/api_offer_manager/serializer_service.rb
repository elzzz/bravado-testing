module ApiOfferManager
  class SerializerService < ApplicationService
    def initialize(offer)
      @offer = offer
    end

    def call
      {
        id: @offer.fetch('id'),
        company: (@offer.fetch('requestor_company') || {}).fetch('name', nil),
        price: @offer.fetch('price'),
        departments: @offer.fetch('departments', []).map {|department| department.fetch('name', '')}
      }
    end
  end
end