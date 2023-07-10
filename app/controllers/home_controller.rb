class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    nickname = session[:nickname]
    github_access_token = session[:github_access_token]

    user_data = GithubApiService.fetch_user(nickname, github_access_token)
    print(user_data)
    @repo_data = GithubApiService.fetch_repos(user_data['repos_url'], github_access_token)
  end
end
