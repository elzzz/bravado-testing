ENV['RAILS_ENV'] ||= 'test'

require "spec_helper"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "shoulda/matchers"

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end
