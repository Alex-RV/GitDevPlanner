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

    save_people_to_db(user, owners_data, collaborators_data)
  end

  private

  def save_people_to_db(user, owners_data, collaborators_data)
    # Save owners data to the database
    owners_data.each do |owner|
      owner_data = {
        owner_id: owner['id'],
        login: owner['login'],
        html_url: owner['html_url']
        # Add other owner-related attributes if available from the API response
      }

      owner_record = Owner.find_or_create_by(owner_id: owner_data[:owner_id])
      owner_record.update(owner_data)

      user.owners << owner_record
    end

    # Save collaborators data to the database
    collaborators_data.each do |collaborator|
      collaborator_data = {
        collaborator_id: collaborator['id'],
        login: collaborator['login'],
        avatar_url: collaborator['avatar_url'],
        html_url: collaborator['html_url'],
        subscriptions: collaborator['subscriptions'].map { |subscription| subscription['name'] },
        organizations: collaborator['organizations'].map { |organization| organization['login'] }
        # Add other collaborator-related attributes if available from the API response
      }

      collaborator_record = Collaborator.find_or_create_by(collaborator_id: collaborator_data[:collaborator_id])
      collaborator_record.update(collaborator_data)

      user.collaborators << collaborator_record
    end
  end
end
