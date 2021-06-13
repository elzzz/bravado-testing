module ApiOfferManager
  class RequestHandlerService < ApplicationService
    ResponseError = Class.new(StandardError)

    def initialize(url, params = {})
      @url = url
      @params = params
    end

    def call
      uri = URI(@url)
      uri.query = URI.encode_www_form(@params)
      response = Net::HTTP.get_response(uri)
      raise ResponseError unless response.is_a? Net::HTTPSuccess

      JSON.parse(response.body)
    end
  end
end