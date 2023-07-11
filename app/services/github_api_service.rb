require 'concurrent-ruby'

class GithubApiService
  def self.fetch_collaborators_and_owners(access_token)
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

    collaborators = Set.new
    owners = Set.new

    # Use parallel processing to fetch collaborators and owners concurrently
    futures = []

    repos_data.each do |repo|
      owner_data = repo['owner']
      collaborators_url = repo['collaborators_url'].gsub('{/collaborator}', '')

      futures << Concurrent::Future.execute { fetch_users(collaborators_url, access_token, exclude_self: true) }
      owners.add(owner_data) unless owner_data['login'] == fetch_current_user_login(access_token)
    end

    # Wait for all futures to complete and collect the results
    futures.each do |future|
      collaborators.merge(future.value)
    end

    { collaborators: collaborators.to_a, owners: owners.to_a }
  end

  def self.fetch_users(url, access_token, exclude_self: false)
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
    users_data.reject! { |user| exclude_self && user['login'] == fetch_current_user_login(access_token) }

    users_data
  end

  def self.fetch_current_user_login(access_token)
    cached_login = Rails.cache.read("current_user_login_#{access_token}")
    return cached_login if cached_login.present?

    uri = URI('https://api.github.com/user')
    headers = {
      'Accept' => 'application/vnd.github+json',
      'Authorization' => "Bearer #{access_token}",
      'User-Agent' => 'GitDevPlanner'
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri, headers)

    response = http.request(request)
    return nil unless response.is_a?(Net::HTTPSuccess)

    user_data = JSON.parse(response.body)
    login = user_data['login']

    Rails.cache.write("current_user_login_#{access_token}", login, expires_in: 1.hour) # Cache the current user login for faster access

    login
  end
end
