# frozen_string_literal: true

ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  user_name: 'khadija.bashir@devsinc.com',
  password: Rails.application.credentials[:RESET_ADMIN_PASS],
  authentication: 'plain',
  enable_starttls_auto: true
}
