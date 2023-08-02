class GithubReposJob < ApplicationJob
  queue_as :default

  def perform(github_access_token, nickname)
    puts 'Starting data fetch and save process...'
    user = User.find_by(nickname: nickname)
    return unless user

    repos_data = GithubApiService.fetch_repos(github_access_token, nickname)
    save_repos_to_db(user, repos_data[:all_repos])
  end

  private

  def save_repos_to_db(user, repos_data)
    repos_data = repos_data.sort_by do |repo|
      if repo['last_commit']
        repo['last_commit']['date'] || Time.at(0)
      else
        Time.at(0)
      end
    end.reverse
    repos_data.each do |repo|
      repo_data = {
        repository_id: repo['id'],
        name: repo['name'],
        owner_login: repo['owner']['login'],
        html_url: repo['html_url'],
        private: repo['private'] ? 'Private' : 'Public',
        pushed_at: repo['pushed_at']&.in_time_zone('Pacific Time (US & Canada)')&.strftime('%Y-%m-%d %H:%M:%S'),
        last_commit_date: nil,
        last_commit_sha: nil,
        last_commit_message: nil,
        last_commit_author: nil,
        updated_repo_at: repo['updated_at'].in_time_zone('Pacific Time (US & Canada)').strftime('%B %e, %Y %l:%M%P')
      }

      if repo['last_commit'].is_a?(Hash)
        last_commit = repo['last_commit']
        puts "LAST!!!", last_commit[:date].in_time_zone('Pacific Time (US & Canada)')
        repo_data[:last_commit_date] = last_commit[:date].in_time_zone('Pacific Time (US & Canada)').strftime('%B %e, %Y %l:%M%P')
        repo_data[:last_commit_sha] = last_commit[:sha]
        repo_data[:last_commit_message] = last_commit[:message]
        repo_data[:last_commit_author] = last_commit[:author]
      end

      repository = Repository.find_or_create_by(name: repo_data[:name], repository_id: repo_data[:repository_id])
      repository.update(repo_data)

      user.repositories << repository
    end
  end
end
