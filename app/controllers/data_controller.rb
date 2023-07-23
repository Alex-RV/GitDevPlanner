class DataController < ApplicationController
    def fetch_data
      GithubDataJob.perform_later(session[:github_access_token], session[:nickname])
      render json: { status: 'Data fetch job enqueued' }
    end
  end
  