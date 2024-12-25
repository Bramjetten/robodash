source "https://rubygems.org"

ruby "3.3.5"

gem "rails", "~> 8.0.0"

# Assets
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 3.0"

# Database
gem "pg", "~> 1.1"

# Server
gem "puma", ">= 5.0"
gem "kamal"

# API
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Mission control for Solid Queue
gem "mission_control-jobs"

# For emails!
gem "postmark-rails"

# HTTParty! for uptime monitoring
gem 'httparty'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "letter_opener"
  gem "hotwire-spark"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

