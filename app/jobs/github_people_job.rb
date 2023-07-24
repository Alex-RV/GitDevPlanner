class GithubPeopleJob < ApplicationJob
    queue_as :default
  
    def perform(github_access_token, nickname)
        user = User.find_by(nickname: nickname)
        return unless user
    
        repos_future = Concurrent::Promise.execute { GithubApiService.fetch_repos(github_access_token, nickname) }
        collaborators_future = Concurrent::Promise.execute { GithubApiService.fetch_collaborators(github_access_token, nickname) }
    
        data = Concurrent::Promise.zip(repos_future, collaborators_future).value
        owners_data = data[0][:owners]
        collaborators_data = data[1]
    
        save_repos_to_db(user, owners_data, collaborators_data)
      end
    
      private
    
      def save_repos_to_db(user, owners_data, collaborators_data)
    
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
    
          repository = Repository.find_or_create_by(name: repo_data[:name], repository_id: repo_data[:repository_id])
          repository.update(repo_data)
    
          user.repositories << repository
        end
      end
  end
  