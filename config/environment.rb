# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

ActionMailer::Base.smtp_settings = {
  user_name: 'qn_service',
  password: 'uhE0u0xgjJlWEPgw',
  address: 'smtp587.sendcloud.net',
  port: 587,
  authentication: 'login',
  enable_starttls_auto: true
}
# Initialize the Rails application.
Rails.application.initialize!
