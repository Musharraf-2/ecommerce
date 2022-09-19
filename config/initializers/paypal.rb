# frozen_string_literal: true

client_id = Rails.application.config_for(:paypal)['client_id']
client_secret = Rails.application.config_for(:paypal)['client_secret']
enviroment = PayPal::SandboxEnvironment.new client_id, client_secret
Paypal = PayPal::PayPalHttpClient.new enviroment
