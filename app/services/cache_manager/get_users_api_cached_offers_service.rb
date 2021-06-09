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
      @perfect_offers, @good_offers, @other_offers = [], [], []

      api_offers = GetApiCachedOffersService.call
      user_departments = @user.departments.map(&lambda { |department| department.name })

      api_offers.each do |api_offer|
        if @user.company == api_offer.fetch(:company)
          if (user_departments & api_offer.fetch(:departments)).length > 0
            api_offer[:label] = 'api_perfect_match'
            @perfect_offers << api_offer
          else
            api_offer[:label] = 'api_good_match'
            @good_offers << api_offer
          end
        else
          api_offer[:label] = 'api_offer'
          @other_offers << api_offer
        end
      end

      top_api_offers = top(5)
      #noinspection RubyYardParamTypeMatch
      $redis.set("api_offers:#{@user.id}", Marshal.dump(top_api_offers))
      top_api_offers
    end

    def top(count=5)
      top_perfect_offers, top_good_offers, top_other_offers = [], [], []

      @perfect_offers.each do |perfect_offer|
        break if count == 0
        perfect_offer.delete(:departments)
        top_perfect_offers << perfect_offer
        count -= 1
      end

      @good_offers.each do |good_offer|
        break if count == 0
        good_offer.delete(:departments)
        top_good_offers << good_offer
        count -= 1
      end

      @other_offers.each do |other_offer|
        break if count == 0
        other_offer.delete(:departments)
        top_other_offers << other_offer
        count -= 1
      end

      [top_perfect_offers, top_good_offers, top_other_offers]
    end
  end
end