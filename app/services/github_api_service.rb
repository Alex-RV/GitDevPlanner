class GithubApiService
    # def self.fetch_user(username, access_token)
    #   uri = URI("https://api.github.com/users/#{username}")
    #   headers = {
    #     'X-GitHub-Api-Version'=> '2022-11-28',
    #     'Authorization' => "Bearer #{access_token}",
    #     'User-Agent' => "GitDevPlanner #{username}"
    #   }
  
    #   http = Net::HTTP.new(uri.host, uri.port)
    #   http.use_ssl = true
  
    #   request = Net::HTTP::Get.new(uri.path, headers)
  
    #   response = http.request(request)
    #   return nil unless response.is_a?(Net::HTTPSuccess)
  
    #   user_data = JSON.parse(response.body)
    #   user_data
    # end
  
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
    
        repos_data = JSON.parse(response.body)
        repos_data
      end
  
    # def self.fetch_user_and_repos(username, access_token)
    #   user_data = fetch_user(username, access_token)
  
    #   return nil if user_data.nil?
  
    #   repos_url = user_data['repos_url']
    #   repos_data = fetch_repos(repos_url, access_token, username)
  
    #   { user_data: user_data, repos_data: repos_data }
    # end
  end
  