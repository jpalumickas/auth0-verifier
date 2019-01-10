# frozen_string_literal: true

source 'https://rubygems.org'

group :development do
  gem 'rubocop', '~> 0.62'
  gem 'rubocop-rspec'
end

group :development, :test do
  gem 'pry'
end

group :test do
  gem 'rake' # For Travis CI
  gem 'rspec', '~> 3.8'
  gem 'simplecov', '~> 0.16', require: false
  gem 'webmock', '~> 3.5'
end

gemspec
