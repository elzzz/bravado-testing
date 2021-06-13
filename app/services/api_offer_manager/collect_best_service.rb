module ApiOfferManager
  class CollectBestService < ApplicationService
    def initialize(user, limit = 5)
      @user = user
      @limit = limit
    end

    def call
      ApiOffer.select(
        "#{ApiOffer.table_name}.*",
        construct_case_label.as('label')
      ).order(:label).limit(@limit)
    end

    private

    def construct_case_label
      ao_table = ApiOffer.arel_table
      aod_table = ApiOfferDepartment.arel_table
      ud_table = UserDepartment.arel_table

      departments_intersect_exists = aod_table.project(1)
                                              .join(ud_table).on(aod_table[:department_id].eq(ud_table[:department_id]))
                                              .where(aod_table[:api_offer_id].eq(ao_table[:id]))
                                              .where(ud_table[:user_id].eq(@user.id))
                                              .exists

      good_match = ao_table[:company].eq(@user.company)
      perfect_match = good_match.and(departments_intersect_exists)

      Arel::Nodes::Case.new.when(
        perfect_match, 1
      ).when(
        good_match, 3
      ).else(5)
    end
  end
end
