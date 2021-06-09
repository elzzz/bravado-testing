module OfferManager
  class GetMatchedOffersService < ApplicationService
    def initialize(user:, company_name:, department_id:, sort:)
      @user = user
      @company_name = company_name
      @department_ids = department_id
      @sort = sort
    end

    def call
      perfect_offers, good_offers, other_offers = [], [], []

      @offers =
        begin
          relation = Offer.includes(:departments)
          if @department_ids.length > 0
            relation = relation.by_departments_ids @department_ids
          end

          relation = relation.by_company_icontains @company_name

          if @sort.in? %w[desc asc]
            relation = relation.by_price_sort @sort.to_sym
          end
          relation
        end

      @offers.each do |offer|
        serialized_offer = serialize(offer)
        if @user.company == offer.company
          if (@user.departments & offer.departments).length > 0
            serialized_offer[:label] = 'local_perfect_match'
            perfect_offers << serialized_offer
          else
            serialized_offer[:label] = 'local_good_match'
            good_offers << serialized_offer
          end
        else
          serialized_offer[:label] = 'local_offer'
          other_offers << serialized_offer
        end
      end

      [perfect_offers, good_offers, other_offers]
    end

    def serialize(offer)
      {
        id: offer.id,
        company: offer.company,
        price: offer.price,
      }
    end
  end
end