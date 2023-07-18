require 'active_support/time'
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def dashboard
  end

  def repositories
    nickname = session[:nickname]
    github_access_token = session[:github_access_token]

    repos_future = Concurrent::Promise.execute { GithubApiService.fetch_repos(github_access_token, nickname) }

    data = Concurrent::Promise.zip(repos_future).value
    # @repos_data = data[0][:all_repos]
    repos_data = data[0][:all_repos]
    @repos_data = repos_data.sort_by do |repo|
      if repo['last_commit']
        repo['last_commit']['date'] || Time.at(0)
      else
        Time.at(0)
      end
    end.reverse
    # repos_data = @repos_data.reject { |repo| repo['last_commit'].nil? }

    # repos_data.each do |repo|
    #   if repo['last_commit']
    #     puts repo['last_commit']['date']
    #   else
    #     puts "No last commit date available"
    #   end
    # end
    

  end

  def people
    nickname = session[:nickname]
    github_access_token = session[:github_access_token]

    repos_future = Concurrent::Promise.execute { GithubApiService.fetch_repos(github_access_token, nickname) }
    collaborators_future = Concurrent::Promise.execute { GithubApiService.fetch_collaborators(github_access_token, nickname) }

    data = Concurrent::Promise.zip(repos_future, collaborators_future).value
    @repos_data = data[0][:all_repos]
    @owners_data = data[0][:owners]
    @collaborators_data = data[1]
  end
end
