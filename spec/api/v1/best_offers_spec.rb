require 'rails_helper'

resource "BestOffers" do
  explanation "Best Offers Resource"
  header "Content-Type", "application/json"
  let(:current_user) { create :user_with_offers }

  get "/api/v1/users/:user_id/best_offers" do

    parameter :user_id, 'ID of the User for whom to find best offers', required: true
    parameter :query, 'Company name or a part to filter offers by'
    parameter :department_id, 'Comma-separated departments ID to filter offers by'
    parameter :sort, 'Sort by price ASC or DESC'
    parameter :page, 'Page of best offers'


    context "With user valid ID and no filters" do
      let(:user_id) { current_user.id }

      example "Successfully listing Best Offers" do
        do_request(request)
        expect(status).to eq(200)
      end

      example "Has 23 Best Offers" do
        do_request(request)
        expect(json_response_body['data'].length).to eq(23)
      end

      example "Has 18 Offers (6 perfect, 6 good, 6 others) and top 5 (2 perfect, 2 good, 1 others) API Offers" do
        do_request(request)
        expect(json_response_body['data'].select { |offer| offer['label'].match(/^local/) }.length).to eq(18)
        expect(json_response_body['data'].select { |offer| offer['label'].match(/^local_perfect/) }.length).to eq(6)
        expect(json_response_body['data'].select { |offer| offer['label'].match(/^local_good/) }.length).to eq(6)
        expect(json_response_body['data'].select { |offer| offer['label'].match(/^local_others/) }.length).to eq(6)

        expect(json_response_body['data'].select { |offer| offer['label'].match(/^api/) }.length).to eq(5)
        expect(json_response_body['data'].select { |offer| offer['label'].match(/^api_perfect/) }.length).to eq(2)
        expect(json_response_body['data'].select { |offer| offer['label'].match(/^api_good/) }.length).to eq(2)
        expect(json_response_body['data'].select { |offer| offer['label'].match(/^api_others/) }.length).to eq(1)
      end
    end

    context "With user valid ID and overflowed page" do
      let(:user_id) { current_user.id }
      let(:page) { 9999 }

      example "Successfully listing Best Offers" do
        do_request(request)
        expect(status).to eq(200)
      end

      example "Has 0 Best Offers" do
        do_request(request)
        expect(json_response_body['data'].length).to eq(0)
      end
    end

    context "With user invalid ID" do
      let(:user_id) { 0 }

      example_request 'User not found' do
        expect(status).to eq(404)
      end
    end
  end
end