module CacheManager
  class GetUsersApiCachedOffersService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      get_or_create
    end

    private

    def get_or_create
      api_offers = get_from_cache
      return api_offers if api_offers

      fill_cache
    end

    def get_from_cache
      cache = $redis.get("api_offers:#{@user.id}")
      return cache unless cache
      Marshal.load(cache)
    end

    def fill_cache
      labeled_offers = get_labeled_offers
      top_api_offers = top(labeled_offers, 5)
      $redis.set("api_offers:#{@user.id}", Marshal.dump(top_api_offers))
      top_api_offers
    end

    def get_labeled_offers
      perfect_offers, good_offers, other_offers = [], [], []

      api_offers = GetApiCachedOffersService.call
      user_departments = @user.departments.map(&lambda { |department| department.name })

      api_offers.each do |api_offer|
        api_offer_departments = api_offer.fetch(:departments)
        api_offer.delete(:departments)
        if @user.company == api_offer.fetch(:company)
          if (user_departments & api_offer_departments).length > 0
            api_offer[:label] = 'api_perfect_match'
            perfect_offers << api_offer
          else
            api_offer[:label] = 'api_good_match'
            good_offers << api_offer
          end
        else
          api_offer[:label] = 'api_offer'
          other_offers << api_offer
        end
      end

      [perfect_offers, good_offers, other_offers]
    end

    def top(offers, count=5)
      perfect_offers, good_offers, other_offers = offers
      top_perfect_offers, top_good_offers, top_other_offers = [], [], []

      slots = count - (top_perfect_offers.length + top_good_offers.length + top_other_offers.length)
      top_perfect_offers += perfect_offers[0...slots]

      slots -= top_perfect_offers.length
      top_good_offers += good_offers[0...slots]

      slots -= top_good_offers.length
      top_other_offers += other_offers[0...slots]

      [top_perfect_offers, top_good_offers, top_other_offers]
    end
  end
end