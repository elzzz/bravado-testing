require 'uri'
require 'net/http'

class ApiOffersCollector
  include Sidekiq::Worker
  $api_uri = "https://bravado.co/api/api/opportunity/intros.json"

  #noinspection RubyUnusedLocalVariable
  def perform(*args)
    puts "========== API OFFERS BEGIN =========="
    #noinspection RubyYardParamTypeMatch
    $redis.set('api_offers', Marshal.dump(get_offers))
    $redis.del(*$redis.scan(0, match: 'api_offers:*'))
    puts "========== API OFFERS END =========="
  end

  private

  def get_offers
    @api_offers = []
    current_page, total_pages = 0, 1

    while current_page < total_pages
      # Testing purpose
      # break if current_page + 1 > 2

      offers, current_page, total_pages = get_offers_by_page.call(current_page + 1)
      #noinspection SpellCheckingInspection
      offers.each do |offer|
        @api_offers << reserialize(offer)
      end
    end

    @api_offers
  end

  def get_offers_by_page
    lambda do | page=1 |
      puts "Page ##{page}"
      uri = URI($api_uri)
      params = { page: page }
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)
      return [], 1, 0 unless response.is_a? Net::HTTPSuccess

      data = JSON.parse response.body
      [data.fetch('intros', []), data.fetch('current_page', page), data.fetch('total_pages', 0)]
    end
  end

  def reserialize(offer)
    {
      id: offer.fetch('id'),
      company: (offer.fetch('requestor_company') || {}).fetch('name', ''),
      price: offer.fetch('price'),
      departments: offer.fetch('departments', []).map(&lambda {|department| department.fetch('name', '')})
    }
  end
end
