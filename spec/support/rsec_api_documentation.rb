require "rspec_api_documentation"
require "rspec_api_documentation/dsl"

RspecApiDocumentation.configure do |config|
  config.app = Rails.application
  config.format = :JSON
  config.docs_dir = Rails.root.join("doc", "api", "v1")
  config.request_headers_to_include = ["Accept", "Content-Type"]
  config.response_headers_to_include = ["Content-Type"]
  config.curl_host = "http://#{ENV.fetch('HOST', 'localhost:8000')}"
  config.curl_headers_to_filter = ["Cookie", "Host", "Origin"]
  config.keep_source_order = true
end