module BestOfferManager
  class PaginateService < ApplicationService
    include Pagy::Backend

    def initialize(user:, departments_ids:, company_name:, price_sort:, page:)
      @user = user
      @departments_ids = departments_ids
      @company_name = company_name
      @price_sort = price_sort
      @page = page
    end

    def call
      best_offers = BestOfferManager::CollectService.call(
        user: @user,
        departments_ids: @departments_ids,
        company_name: @company_name,
        price_sort: @price_sort
      )

      pagination, best_offers_paginated = pagy(best_offers, items: Offer.per_page, page: @page)

      {
        data: ActiveModelSerializers::SerializableResource.new(
          best_offers_paginated, each_serializer: BestOfferSerializer
        ).as_json,
        pagination: {
          total_count: pagination.count,
          total_pages: pagination.pages,
          current_page: pagination.page,
          next_page: pagination.next,
          on_page: pagination.items,
          per_page: Offer.per_page,
        }
      }
    end
  end
end