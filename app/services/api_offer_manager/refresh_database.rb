module ApiOfferManager
  class RefreshDatabase < ApplicationService
    def call
      ActiveRecord::Base.transaction do
        ApiOfferDepartment.delete_all
        ApiOffer.delete_all
        api_offers = Bravado::Client.new.get_api_offers
        api_offers.each do |api_offer|
          ApiOfferManager::Create.call(api_offer)
        end
      end
    end
  end
end
