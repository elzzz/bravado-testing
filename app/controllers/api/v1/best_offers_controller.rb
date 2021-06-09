class Api::V1::BestOffersController < ApplicationController
  def index
    page = params[:page] ? [params[:page].to_i, 1].max : 1

    @user = User.includes(:departments).left_outer_joins(:departments).find_by(id: params[:user_id])
    unless @user
      render json: { data: [], message: "User not found" }, status: :not_found
      return
    end

    @local_perfect_offers, @local_good_offers, @local_other_offers = OfferManager::GetMatchedOffersService.call(
      @user,
      params[:query],
      params[:department_id],
      params[:sort]
    )

    @api_perfect_offers, @api_good_offers, @api_other_offers = CacheManager::GetUsersApiCachedOffersService.call(
      @user
    )

    offers = [
      *@local_perfect_offers.as_json(only: Offer.serialization_fields),
      *@api_perfect_offers,
      *@local_good_offers.as_json(only: Offer.serialization_fields),
      *@api_good_offers,
      *@local_other_offers.as_json(only: Offer.serialization_fields),
      *@api_other_offers
    ]

    paginated_offers = offers[0 + 30 * (page - 1)...Offer.per_page * page] || []
    render json: {
      data: paginated_offers,
      total_count: offers.length,
      total_pages: (offers.length / Offer.per_page.to_f).ceil,
      current_page: page,
      per_page: Offer.per_page,
      message: "Success"
    }, status: :ok
  end
end
