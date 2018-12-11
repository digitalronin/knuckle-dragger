require "net/http"
require "uri"

class GithubOauth
  ACCESS_TOKEN_URL = 'https://github.com/login/oauth/access_token'

  # Exchange the github 'code' for an oauth token
  def self.get_token_from_code(code)
    uri = URI.parse(ACCESS_TOKEN_URL)

    response = Net::HTTP.post_form(uri, {
      code: code,
      client_id: ENV.fetch('GITHUB_CLIENT_ID'),
      client_secret: ENV.fetch('GITHUB_CLIENT_SECRET')
    })

    # Response.body should look like this
    # access_token=370394bc61157a9ff0c441928ddae9b3a764afc1&scope=repo&token_type=bearer
    if response.body =~ /access_token=(\w+)/
      $1
    else
      raise "No access_token found in github response: #{response body}"
    end
  end
end
