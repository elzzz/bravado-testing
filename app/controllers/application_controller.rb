class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Pagy::Backend
end
