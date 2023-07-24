# lib/tasks/github.rake
namespace :github do
    desc "Fetch data from GitHub API and update the database"
    task update_data: :environment do
        puts("IT WORKSSSS")
    #   github_access_token = Rails.application.credentials.github[:access_token]
    #   nickname = Rails.application.credentials.github[:nickname]
  
    #   data = GithubApiService.fetch_repos(github_access_token, nickname)
    #   all_repos = data[:all_repos]
    #   owners = data[:owners]
  
    #   # Save data to the database here
    #   # For example, update the Repo and Owner models with the fetched data
    #   # Note: You'll need to define your Repo and Owner models with appropriate attributes
  
    #   all_repos.each do |repo_data|
    #     repo = Repo.find_or_initialize_by(id: repo_data['id'])
    #     repo.update(repo_data)
    #   end
  
    #   owners.each do |owner_data|
    #     owner = Owner.find_or_initialize_by(id: owner_data['id'])
    #     owner.update(owner_data)
    #   end
    end
  end
  