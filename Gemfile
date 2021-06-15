source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

# The most important stuff
gem 'pg'
gem 'rails', '~> 6.1.3', '>= 6.1.3.2'

# All others gems
gem 'puma', '~> 5.0'
gem 'active_model_serializers'
gem 'pagy'
gem 'active_record_union'
gem 'sidekiq'
gem 'sidekiq-scheduler', '~> 3.1.0'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'bullet'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :test do
  gem "shoulda-matchers", require: false
  gem 'rspec_api_documentation'
end

