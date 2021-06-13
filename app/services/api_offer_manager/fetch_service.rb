module ApiOfferManager
  class FetchService < ApplicationService
    def initialize
    end

    def call
      api_offers = []
      current_page = 0

      loop do
        api_offers_part, current_page, total_pages = fetch_paginated_api_offers current_page + 1
        api_offers += api_offers_part

        break if current_page >= total_pages
      end

      api_offers
    end

    private

    def fetch_paginated_api_offers(page)
      api_offers = ApiOfferManager::RequestHandlerService.call(api_url, {page: page})
      ApiOfferManager::ResponseProcessorService.call api_offers
    end

    def api_url
      "https://bravado.co/api/api/opportunity/intros.json"
    end
  end
end