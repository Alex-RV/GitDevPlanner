class DashboardController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @user = current_user
    @repos_with_tasks = @user.repositories.joins(:tasks).distinct
    @collaborators_with_notes = @user.collaborators.joins(:notes).distinct
    @owners_with_notes = @user.owners.joins(:notes).distinct

    @notes = @user.notes
    @tasks = @user.tasks
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

    @collaborators_notes = retrieve_notes_for_users(@collaborators_data)
    @owners_notes = retrieve_notes_for_users(@owners_data)

    nickname = session[:nickname]
    github_access_token = session[:github_access_token]
    GithubPeopleJob.perform_later(github_access_token, nickname)
  end

  def create_note
    @note = Note.new(note_params)
    @note.user = current_user

    if @note.save
      redirect_back(fallback_location: dashboard_path, notice: 'Note created successfully.')
    else
      redirect_back(fallback_location: dashboard_path, alert: 'Failed to create note.')
    end
  end

  def create_task
    task = Task.new(task_params)

    user = current_user

    task.user = user

    if task.save
      redirect_to repositories_path, notice: 'Task created successfully.'
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

  def delete_note
    note = Note.find_by(id: params[:id])

    if note && note.user == current_user
      note.destroy
      redirect_back(fallback_location: dashboard_path, notice: 'Note deleted successfully.')
    else
      redirect_back(fallback_location: dashboard_path, alert: 'Failed to delete note.')
    end
  end

  private

  def task_params
    params.require(:task).permit(:repository_id, :title, :description)
  end

  def note_params
    params.require(:note).permit(:content, :notable_type, :notable_id)
  end

  def retrieve_notes_for_users(users)
    user_ids = users.pluck(:id)
    Note.where(notable_type: users.first.class.name, notable_id: user_ids).group_by(&:notable_id)
  end
end