module CacheManager
  class GetApiCachedOffersService < ApplicationService
    def initialize
    end

    def call
      Marshal.load($redis.get('api_offers') || [])
    end
  end
end