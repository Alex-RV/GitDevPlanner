class DashboardController < ApplicationController
  before_action :authenticate_user!

  def dashboard
  end

  def repositories
    github_access_token = session[:github_access_token]
    repos_future = Concurrent::Promise.execute { GithubApiService.fetch_repos(github_access_token) }
    data = repos_future.value
    @repos_data = data[:all_repos]
  end

  def people
    github_access_token = session[:github_access_token]
    nickname = session[:nickname]

    repos_future = Concurrent::Promise.execute { GithubApiService.fetch_repos(github_access_token) }
    collaborators_future = Concurrent::Promise.execute { GithubApiService.fetch_collaborators(github_access_token, nickname) }

    data = Concurrent::Promise.zip(repos_future, collaborators_future).value
    @repos_data = data[0][:all_repos]
    @owners_data = data[0][:owners]
    @collaborators_data = data[1]
  end
end
