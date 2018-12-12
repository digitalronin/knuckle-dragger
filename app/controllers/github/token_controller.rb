class Github::TokenController < ApplicationController
  def req
    if session[:github_access_token]
      redirect_to '/'
    else
      state = random_string
      session[:github_oauth_state] = state
      redirect_to github_token_request_url(state)
    end
  end

  def store
    unless params.fetch(:state) == session[:github_oauth_state]
      raise("Returned state parameter does not match original request")
    end

    code = params.fetch(:code)
    token = GithubOauth.get_token_from_code(code)
    Rails.logger.debug "token: #{token}"

    session[:github_access_token] = token
    redirect_to '/'
  end

  private

  def random_string
    (0...32).map { (65 + rand(26)).chr }.join
  end

  def github_token_request_url(state)
    'https://github.com/login/oauth/authorize?' + {
      client_id: ENV.fetch('GITHUB_CLIENT_ID'),
      scope: 'repo',
      state: state
    }.to_query
  end
end
