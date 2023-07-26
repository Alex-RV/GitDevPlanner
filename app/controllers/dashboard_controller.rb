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
    nickname = session[:nickname]
    github_access_token = session[:github_access_token]
    GithubReposJob.perform_later(github_access_token, nickname)

    @tasks = @user.tasks

  end

  def people
    @user = current_user
    @collaborators_data = @user.collaborators
    @owners_data = @user.owners

    nickname = session[:nickname]
    github_access_token = session[:github_access_token]
    GithubPeopleJob.perform_later(github_access_token, nickname)
  end

  def create_task
    task = Task.new(task_params)

    user = current_user

    task.user = user

    if task.save
      redirect_to dashboard_path, notice: 'Task created successfully.'
    else
      @repos_data = user.repositories
      @tasks = user.tasks
      flash.now[:alert] = 'Failed to create task.'
      render :repositories
    end
  end

  def delete_task
    # Find the task by ID
    task = Task.find_by(id: params[:id])

    # If the task is found and belongs to the current user, delete it
    if task && task.user == current_user
      task.destroy
      redirect_to repositories_path, notice: 'Task deleted successfully.'
    else
      redirect_to repositories_path, alert: 'Failed to delete task.'
    end
  end

  private

  def task_params
    params.require(:task).permit(:repository_id, :title, :description)
  end
  

  
end