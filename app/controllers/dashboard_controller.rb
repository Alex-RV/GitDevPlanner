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

    @tasks = Task.where(user_id: current_user.id)

    

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

def create_task
    @task = Task.new(task_params)
    @task.user_id = current_user.id

    if @task.save
      redirect_to root_path, notice: 'Task created successfully.'
    else
      redirect_to root_path, alert: 'Failed to create task.'
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :scheduled_at, :repository_id)
  end

  
end
