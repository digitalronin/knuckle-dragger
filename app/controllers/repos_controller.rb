class ReposController < ApplicationController

  def create
    repo = repo_params.fetch(:url).sub('https://github.com/', '').strip
    redirect_to repo_path(repo)
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
