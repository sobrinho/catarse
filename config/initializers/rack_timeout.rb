# Recommended config in Heroku docs:
# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#timeout
Rack::Timeout.timeout = 25  # seconds
