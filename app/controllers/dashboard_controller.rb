require 'active_support/time'
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def dashboard
  end

  def repositories
    @user = current_user
    repos_data = @user.repositories
    @repos_data = repos_data.sort_by do |repo|
      if repo.last_commit_date
        repo.last_commit_date || Time.at(0)
      else
        Time.at(0)
      end
    end.reverse
    # nickname = session[:nickname]
    # github_access_token = session[:github_access_token]

    # repos_future = Concurrent::Promise.execute { GithubApiService.fetch_repos(github_access_token, nickname) }

    # data = Concurrent::Promise.zip(repos_future).value
    # repos_data = data[0][:all_repos]
    # @repos_data = repos_data.sort_by do |repo|
    #   if repo['last_commit']
    #     repo['last_commit']['date'] || Time.at(0)
    #   else
    #     Time.at(0)
    #   end
    # end.reverse
    # print("Tasks:",Task.where(user_id: current_user.id).to_a)

    @tasks = Task.where(user_id: current_user.id).to_a

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
    task = Task.new(task_params)
    print("!task_params!:::",task_params)
    task.user_id = current_user.id
    print("!current_user.id!",current_user.id)
    
    task.repository = task_params[:repository_id].to_i 
    # print("!@task!:::",@task.save)
    # task = Task.new(title: "My Task", description: "Task description", repository: 6345345, user: current_user)
    # task.save
  
    if task.save
      redirect_to root_path, notice: 'Task created successfully.'
    else
      puts "Errors: #{task.errors.full_messages}"
      redirect_to settings_path, alert: 'Failed to create task.'
    end
  end
   

  private

  def task_params
    params.require(:task).permit(:title, :description, :repository_id)
  end
  

  
end