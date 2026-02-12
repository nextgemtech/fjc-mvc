require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FjcShop
  class Application < Rails::Application
    config.load_defaults 7.1

    config.session_store :cookie_store, key: '_app_session'

    config.time_zone = 'Singapore'
    config.active_record.default_timezone = :local
    config.action_view.default_form_builder = "OverrideFormBuilder"

    config.generators do |g|
      g.template_engine = :haml
      g.test_framework(:rspec, fixtures: false, view_specs: false, helper_specs: false, routing_specs: false)
    end
  end
end
