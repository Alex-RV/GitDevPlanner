require 'concurrent-ruby'

class GithubApiService
  def self.fetch_repos(access_token, nickname)
    uri = URI('https://api.github.com/user/repos')
    headers = {
      'Accept' => 'application/vnd.github+json',
      'Authorization' => "Bearer #{access_token}",
      'User-Agent' => 'GitDevPlanner'
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.path, headers)

    response = http.request(request)
    return nil unless response.is_a?(Net::HTTPSuccess)

    user_repos = JSON.parse(response.body)

    params = {
      'affiliation' => 'collaborator,contributor',
      'visibility' => 'all'
    }

    uri.query = URI.encode_www_form(params)

    request = Net::HTTP::Get.new(uri, headers)

    response = http.request(request)
    return nil unless response.is_a?(Net::HTTPSuccess)

    other_repos = JSON.parse(response.body)

    all_repos = (user_repos + other_repos).uniq { |repo| repo['id'] }

    # Fetch last commit for each repo in parallel
    promises = all_repos.map do |repo|
      Concurrent::Promise.execute { fetch_last_commit(repo, access_token, nickname) }
    end

    # Wait for all promises to complete
    Concurrent::Promise.zip(*promises).wait

    # Owners of the repos
    owners = Set.new

    other_repos.each do |repo|
      owner_data = repo['owner']

      owners.add(owner_data)
    end

    { all_repos: all_repos, owners: owners.to_a }
  end

  def self.fetch_collaborators(access_token, nickname)
    uri = URI('https://api.github.com/user/repos')
    headers = {
      'Accept' => 'application/vnd.github+json',
      'Authorization' => "Bearer #{access_token}",
      'User-Agent' => 'GitDevPlanner'
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.path, headers)

    response = http.request(request)
    return nil unless response.is_a?(Net::HTTPSuccess)

    repos_data = JSON.parse(response.body)

    collaborators = Concurrent::Set.new

    # Use parallel processing to fetch collaborators concurrently
    promises = []

    repos_data.each do |repo|
      collaborators_url = repo['collaborators_url'].gsub('{/collaborator}', '')

      promises << Concurrent::Promise.execute { fetch_users(collaborators_url, access_token, nickname, exclude_self: true) }
    end

    # Wait for all promises to complete and collect the results
    promises.each do |promise|
      promise.value.each { |user| collaborators.add(user) }
    end

    # Fetch subscriptions and organizations data for each collaborator asynchronously
    promises = []

    collaborators.each do |collaborator|
      subscriptions_url = collaborator['subscriptions_url'].gsub('{/other_user}', '')
      organizations_url = collaborator['organizations_url']

      # Fetch subscriptions and organizations concurrently
      promises << Concurrent::Promise.execute do
        subscriptions = fetch_data(subscriptions_url, access_token)
        organizations = fetch_data(organizations_url, access_token)

        collaborator['subscriptions'] = subscriptions
        collaborator['organizations'] = organizations
      end
    end

    # Wait for all promises to complete
    promises.each(&:wait)

    collaborators.to_a.uniq { |user| user['login'] }
  end

  def self.fetch_data(url, access_token)
    headers = {
      'Accept' => 'application/vnd.github+json',
      'Authorization' => "Bearer #{access_token}",
      'User-Agent' => 'GitDevPlanner'
    }

    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.path, headers)

    response = http.request(request)
    return [] unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    data
  end

  def self.fetch_users(url, access_token, nickname, exclude_self: false)
    headers = {
      'Accept' => 'application/vnd.github+json',
      'Authorization' => "Bearer #{access_token}",
      'User-Agent' => 'GitDevPlanner'
    }

    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.path, headers)

    response = http.request(request)
    return [] unless response.is_a?(Net::HTTPSuccess)

    users_data = JSON.parse(response.body)

    # Exclude self from collaborators data if specified
    users_data.reject! { |user| exclude_self && user['login'] == nickname }

    users_data
  end

  def self.fetch_last_commit(repo, access_token, nickname)
    commits_url = repo['commits_url'].gsub('{/sha}', '') + "?author=#{nickname}"

    headers = {
      'Accept' => 'application/vnd.github+json',
      'Authorization' => "Bearer #{access_token}",
      'User-Agent' => 'GitDevPlanner'
    }

    uri = URI(commits_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.path + '?' + uri.query, headers)

    response = http.request(request)
    return unless response.is_a?(Net::HTTPSuccess)

    commits_data = JSON.parse(response.body)

    # Fetch commits from all branches
    branches_url = repo['branches_url'].gsub('{/branch}', '')
    branches = fetch_data(branches_url, access_token)

    most_recent_commit = nil

    branches.each do |branch|
      branch_name = branch['name']
      branch_commits_url = "#{commits_url}&sha=#{branch_name}"

      branch_request = Net::HTTP::Get.new(URI(branch_commits_url).path + '?' + URI(branch_commits_url).query, headers)
      branch_response = http.request(branch_request)

      if branch_response.is_a?(Net::HTTPSuccess)
        branch_commits_data = JSON.parse(branch_response.body)
        last_commit = branch_commits_data.first

        if last_commit
          commit_date = DateTime.parse(last_commit['commit']['author']['date'])
          if most_recent_commit.nil? || commit_date > most_recent_commit[:date]
            most_recent_commit = {
              sha: last_commit['sha'],
              message: last_commit['commit']['message'],
              author: last_commit['commit']['author']['name'],
              date: commit_date
            }
          end
        end
      end
    end

    # Fetch the last commit for the main branch (default branch)
    main_branch_last_commit = commits_data.first

    if main_branch_last_commit
      main_branch_commit_date = DateTime.parse(main_branch_last_commit['commit']['author']['date'])
      if most_recent_commit.nil? || main_branch_commit_date > most_recent_commit[:date]
        most_recent_commit = {
          sha: main_branch_last_commit['sha'],
          message: main_branch_last_commit['commit']['message'],
          author: main_branch_last_commit['commit']['author']['name'],
          date: main_branch_commit_date
        }
      end
    end

    repo['last_commit'] = most_recent_commit
  end

end
