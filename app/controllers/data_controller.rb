class DataController < ApplicationController
  @@job_triggered = false

  def fetch_data
    if @@job_triggered
      render json: { status: 'Data fetch job already triggered' }
    else
      GithubDataJob.perform_later(session[:github_access_token], session[:nickname])
      @@job_triggered = true
      render json: { status: 'Data fetch job enqueued' }
    end
  end
end
