require 'net/http'
require 'uri'

module Bravado
  class Client
    API_OFFERS_URL = "https://bravado.co/api/api/opportunity/intros.json"

    def get_api_offers
      get_resources(API_OFFERS_URL, Bravado::ApiOffer, 'intros')
    end

    private

    def get_resources(url, object, resource)
      resources = []
      current_page = 0

      loop do
        data = get_resource_page(url, current_page + 1)
        resources_part = data.fetch(resource, [])
        resources += resources_part.map { |resource_data| object.new(resource_data) }

        current_page, total_pages = data.fetch('current_page', 0), data.fetch('total_pages', 0)
        break if current_page >= total_pages
      end

      resources
    end

    def get_resource_page(url, page)
      uri = URI(url)
      uri.query = URI.encode_www_form({page: page})
      response = Net::HTTP.get_response(uri)
      raise ResponseError unless response.is_a? Net::HTTPSuccess

      JSON.parse(response.body)
    end
  end
end