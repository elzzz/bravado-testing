module BestOfferManager
  class Collect < ApplicationService
    def initialize(user:, departments_ids:, company_name:, price_sort:)
      @user = user
      @departments_ids = departments_ids
      @company_name = company_name
      @price_sort = price_sort
    end

    def call
      local_best_offers = OfferManager::CollectBest.call(
        user: @user,
        departments_ids: @departments_ids,
        company_name: @company_name,
        price_sort: @price_sort
      )

      api_best_offers = ApiOfferManager::CollectBest.call(@user)

      local_best_offers.union_all(api_best_offers).order(:label)
    end
  end
end