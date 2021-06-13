class ApiOffersCollector
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    api_offers = ApiOfferManager::FetchService.call
    ApiOfferManager::RefreshDatabaseService.call api_offers
  end
end
