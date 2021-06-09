class Api::V1::BestOffersController < ApplicationController
  def index
    user = User.includes(:departments).find_by(id: params[:user_id])
    unless user
      render json: { data: [], message: "User not found" }, status: :not_found
      return
    end

    render json: OfferManager::PaginateBestOffersService.call(
        user: user,
        query: offers_params[:query],
        department_id: offers_params[:department_id].split(','),
        sort: offers_params[:sort],
        page: offers_params[:page]
    ), status: :ok
  end

  def offers_params
    params.permit(:user_id, :query, :department_id, :sort, :page, :format)
          .reverse_merge({query: '', department_id: '', sort: '', page: 1})
  end
end
