class GithubDataJob < ApplicationJob
    queue_as :default
  
    def perform(access_token, nickname)
      puts 'Starting data fetch and save process...'
      data = GithubApiService.fetch_repos(access_token, nickname)
      print("!!!was fetch!!!:",data)
    end
  end
  