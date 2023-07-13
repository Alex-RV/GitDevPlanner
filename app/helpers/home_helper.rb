# app/helpers/home_helper.rb

module HomeHelper
    def fetch_subscriptions(collaborator_url, access_token)
      fetch_data("#{collaborator_url}/subscriptions", access_token)
    end
  
    def fetch_organizations(collaborator_url, access_token)
      fetch_data("#{collaborator_url}/orgs", access_token)
    end
  
    private
  
    def fetch_data(url, access_token)
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
  
      JSON.parse(response.body)
    end
  end
  