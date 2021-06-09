module OfferManager
  class GetMatchedOffersService < ApplicationService
    def initialize(user, company_name=nil, department_id=nil, sort=nil)
      @user = user
      @company_name = company_name || ''
      @department_ids = department_id ? department_id.split(",") : []
      @sort = sort || ''
    end

    def call
      @perfect_offers, @good_offers, @other_offers = [], [], []

      @offers =
        begin
          # relation = Offer.includes(:departments).left_outer_joins(:departments).distinct
          relation = Offer.includes(:departments)
          if @department_ids.length > 0
            relation = relation.by_departments_ids @department_ids
          end

          #noinspection SpellCheckingInspection
          relation = relation.by_company_icontains @company_name

          if @sort.in? %w[desc asc]
            #noinspection RubyNilAnalysis
            relation = relation.by_price_sort @sort.to_sym
          end
          relation
        end

      @offers.each do |offer|
        if @user.company == offer.company
          if (@user.departments & offer.departments).length > 0
            offer.label = 'local_perfect_match'
            @perfect_offers << offer
          else
            offer.label = 'local_good_match'
            @good_offers << offer
          end
        else
          offer.label = 'local_offer'
          @other_offers << offer
        end
      end

      [@perfect_offers, @good_offers, @other_offers]
    end
  end
end