class Api::V1::BestOffersController < ApplicationController
  def index
    user = User.find_by(id: params[:user_id])
    render status: :not_found and return unless user

    render json: BestOfferManager::PaginateService.call(
        user: user,
        company_name: offers_params[:query],
        departments_ids: offers_params[:department_id].split(',').map(&:strip),
        price_sort: offers_params[:sort],
        page: offers_params[:page]
    ), status: :ok
  end

  def offers_params
    params.permit(:user_id, :query, :department_id, :sort, :page, :format)
          .reverse_merge({department_id: '', page: 1})
  end
end
