# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001'
    resource 'api/v1/products', headers: :any, methods: %i[get]
  end
end
