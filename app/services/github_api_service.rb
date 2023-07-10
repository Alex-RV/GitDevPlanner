class GithubApiService
    def self.fetch_user(username, access_token)
      uri = URI("https://api.github.com/users/#{username}")
      headers = {
        'Authorization' => "Bearer #{access_token}",
        'User-Agent' => 'Your-App-Name'
      }
  
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
  
      request = Net::HTTP::Get.new(uri.path, headers)
  
      response = http.request(request)
      return nil unless response.is_a?(Net::HTTPSuccess)
  
      user_data = JSON.parse(response.body)
      user_data
    end
  
    def self.fetch_repos(repos_url, access_token)
      headers = {
        'Authorization' => "Bearer #{access_token}",
        'User-Agent' => 'Your-App-Name'
      }
    
      uri = URI(repos_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
    
      request = Net::HTTP::Get.new(uri.path, headers)
    
      response = http.request(request)
      return nil unless response.is_a?(Net::HTTPSuccess)
    
      repos_data = JSON.parse(response.body)
      repos_data
    end
  end
  