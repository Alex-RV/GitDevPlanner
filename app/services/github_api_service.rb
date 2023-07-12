require 'concurrent-ruby'

class GithubApiService
    def self.fetch_repos(access_token)
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
    
        collaborators = Set.new
    
        # Use parallel processing to fetch collaborators concurrently
        futures = []
    
        repos_data.each do |repo|
          collaborators_url = repo['collaborators_url'].gsub('{/collaborator}', '')
    
          futures << Concurrent::Future.execute { fetch_users(collaborators_url, access_token, nickname, exclude_self: true) }
        end
    
        # Wait for all futures to complete and collect the results
        futures.each do |future|
          collaborators.merge(future.value)
        end
    
        collaborators.to_a.uniq { |user| user['login'] }
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
end
