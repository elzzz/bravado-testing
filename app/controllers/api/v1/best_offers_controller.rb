class Api::V1::BestOffersController < ApplicationController
  def index
    user = User.find_by(id: params[:user_id])
    render status: :not_found and return unless user

    best_offers = BestOfferManager::Collect.call(
      user: user,
      departments_ids: offers_params[:department_id].split(',').map(&:strip),
      company_name: offers_params[:query],
      price_sort: offers_params[:sort]
    )

    pagination, best_offers_paginated = pagy(best_offers, items: Offer.per_page)

    render json: {
      data: ActiveModelSerializers::SerializableResource.new(
        best_offers_paginated, each_serializer: BestOfferSerializer
      ).as_json,
      pagination: {
        total_count: pagination.count,
        total_pages: pagination.pages,
        current_page: pagination.page,
        next_page: pagination.next,
        on_page: pagination.items,
        per_page: Offer.per_page,
      }
    }, status: :ok
  end

  def offers_params
    params.permit(:user_id, :query, :department_id, :sort, :page, :format)
          .reverse_merge({department_id: '', page: 1})
  end
end
