class GithubDataJob < ApplicationJob
    queue_as :default
  
    def perform(access_token, nickname)
      data = GithubApiService.fetch_repos(access_token, nickname)
      print("!!!was fetch!!!:",data)
    end
  end
  