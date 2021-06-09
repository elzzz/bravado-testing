module OfferManager
  class PaginateBestOffersService < ApplicationService
    def initialize(user:, query:, department_id:, sort:, page:)
      @offers = OfferManager::CollectBestOffersService.call(
        user: user,
        company_name: query,
        department_id: department_id,
        sort: sort
      )
      @page = page
    end

    def call
      {
        data: @offers[0 + Offer.per_page * (@page - 1)...Offer.per_page * @page] || [],
        total_count: @offers.length,
        total_pages: (@offers.length / Offer.per_page.to_f).ceil,
        current_page: @page,
        per_page: Offer.per_page,
      }
    end
  end
end