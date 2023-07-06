Rails.application.config.middleware.use OmniAuth::Builder do
    provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'],
             callback_url: 'http://localhost:3000/auth/github/callback'
  end
  