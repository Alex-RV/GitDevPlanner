# app/helpers/application_helper.rb

module ApplicationHelper
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
  