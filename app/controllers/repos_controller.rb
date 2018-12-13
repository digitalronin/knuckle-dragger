class ReposController < ApplicationController

  def create
    full_name = repo_params.fetch(:url).sub('https://github.com/', '').strip
    redirect_to repo_path(full_name)
  end

  def show
    Rails.logger.debug "Token: #{session[:github_access_token]}"
    @repo = GithubRepo.new(params.fetch(:id), session[:github_access_token])
  end

  private

  def repo_params
    params.require(:repo).permit(:url)
  end
end
