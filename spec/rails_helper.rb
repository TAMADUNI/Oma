# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# require 'webdrivers'  # Commented out - using Selenium Manager instead
require 'simplecov'
require 'simplecov-tailwindcss'

SimpleCov.start

SimpleCov.formatters =
  SimpleCov::Formatter::MultiFormatter.new(
    [SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::TailwindFormatter],
  )

# ========== FIXED CAPYBARA CONFIGURATION ==========
Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  options.binary = "/snap/bin/chromium"

  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-setuid-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1400,1400")
  options.add_argument("--disable-gpu")
  options.add_argument("--remote-debugging-port=9222")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver = :selenium_chrome
Capybara.javascript_driver = :selenium_chrome
# =================================================

# Rest of your configuration remains the same...
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]
  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
end

Shoulda::Matchers.configure do |shoulda_config|
  shoulda_config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end