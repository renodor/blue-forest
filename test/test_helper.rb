ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

# rubocop:disable Metrics/LineLength
class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures %w[categories products product_categories product_variations users fake_users addresses carts orders line_items]

  # Devise test helpers
  include Warden::Test::Helpers
  Warden.test_mode!
end

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[no-sandbox headless disable-gpu window-size=1400,900])
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
# rubocop:enable Metrics/LineLength
Capybara.save_path = Rails.root.join('tmp/capybara')
Capybara.javascript_driver = :headless_chrome
