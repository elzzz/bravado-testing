module ApiOfferManager
  class RefreshDatabaseService < ApplicationService
    def initialize(api_offers)
      @api_offers = api_offers
    end

    def call
      ActiveRecord::Base.transaction do
        ApiOfferDepartment.delete_all
        ApiOffer.delete_all
        fill_database
      end
    end

    private

    def fill_database
      @api_offers.each do |params|
        api_offer = ApiOfferManager::CreateService.call(
          id: params[:id],
          company: params[:company],
          price: params[:price]
        )

        params[:departments].each do |name|
          department = Department.find_by_name(name)
          ApiOfferDepartmentManager::CreateService.call(api_offer, department) if department
        end
      end
    end

  end
end
