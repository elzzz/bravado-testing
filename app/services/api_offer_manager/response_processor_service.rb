module ApiOfferManager
  class ResponseProcessorService < ApplicationService
    def initialize(data)
      @data = data
    end

    def call
      [
        @data.fetch('intros', []).map { |offer| ApiOfferManager::SerializerService.call offer },
        @data.fetch('current_page', 0),
        @data.fetch('total_pages', 0)
      ]
    end
  end
end