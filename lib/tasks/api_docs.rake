require 'rspec/core/rake_task'

desc 'Generate API request documentation from API specs'
RSpec::Core::RakeTask.new('api_docs:generate') do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = ['--format RspecApiDocumentation::ApiFormatter', '--tag ~@document:false']
end