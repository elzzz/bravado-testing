module OfferManager
  class CollectBestOffersService < ApplicationService
    def initialize(user:, company_name:, department_id:, sort:)
      @user = user
      @company_name = company_name
      @department_ids = department_id
      @sort = sort
    end

    def call
      local_perfect_offers, local_good_offers, local_other_offers = OfferManager::GetMatchedOffersService.call(
        user: @user,
        company_name: @company_name,
        department_id: @department_ids,
        sort: @sort
      )

      api_perfect_offers, api_good_offers, api_other_offers = CacheManager::GetUsersApiCachedOffersService.call(
        @user
      )

      [
        *local_perfect_offers,
        *api_perfect_offers,
        *local_good_offers,
        *api_good_offers,
        *local_other_offers,
        *api_other_offers
      ]
    end
  end
end