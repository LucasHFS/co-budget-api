# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
     origins ['https://co-budget-api-73b5996710e3.herokuapp.com']
    resource '*',
             headers: :any,
             expose: %w[Authorization],
             methods: %i[get post put patch delete head options]
  end
end
