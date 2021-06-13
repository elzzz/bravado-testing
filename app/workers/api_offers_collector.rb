class ApiOffersCollector
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    ApiOfferManager::RefreshDatabase.call
  end
end
