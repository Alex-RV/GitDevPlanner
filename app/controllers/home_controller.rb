class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    nickname = session[:nickname]
    github_access_token = session[:github_access_token]

    # data = GithubApiService.fetch_user_and_repos(nickname, github_access_token)
    # @repos_data = data[:repos_data]
    
    # @repos_data = GithubApiService.fetch_repos(github_access_token)

    profiles_data = GithubApiService.fetch_collaborators_and_owners(github_access_token)
    @collaborators_data = profiles_data[:collaborators]
    @owners_data = profiles_data[:owners]
    # print(@repos_data)
  end
end
