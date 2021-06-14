module OfferManager
  class Filter < ApplicationService
    def initialize(departments_ids:, company_name:, price_sort:)
      @departments_ids = departments_ids
      @company_name = company_name
      @price_sort = price_sort
    end

    def call
      relation = Offer.all

      relation = relation.by_departments_ids(@departments_ids) if @departments_ids.length > 0
      relation = relation.by_company_icontains(@company_name) if @company_name
      relation = relation.by_price_sort(@price_sort) if @price_sort.in?(%w[desc asc])

      relation
    end
  end
end
