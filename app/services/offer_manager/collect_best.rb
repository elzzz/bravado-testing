module OfferManager
  class CollectBest < ApplicationService
    def initialize(user:, departments_ids:, company_name:, price_sort:)
      @user = user
      @departments_ids = departments_ids
      @company_name = company_name
      @price_sort = price_sort
    end

    def call
      relation = OfferManager::Filter.call(
        departments_ids: @departments_ids,
        company_name: @company_name,
        price_sort: @price_sort
      )

      relation.select(
        "#{Offer.table_name}.*",
        construct_case_label.as('label')
      )
    end

    private

    def construct_case_label
      o_table = Offer.arel_table
      od_table = OfferDepartment.arel_table
      ud_table = UserDepartment.arel_table

      departments_intersect_exists = od_table.project(1)
                                             .join(ud_table).on(od_table[:department_id].eq(ud_table[:department_id]))
                                             .where(od_table[:offer_id].eq(o_table[:id]))
                                             .where(ud_table[:user_id].eq(@user.id))
                                             .exists

      good_match = o_table[:company].eq(@user.company)
      perfect_match = good_match.and(departments_intersect_exists)

      Arel::Nodes::Case.new.when(
        perfect_match, 0
      ).when(
        good_match, 2
      ).else(4)
    end
  end
end