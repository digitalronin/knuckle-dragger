class ReposController < ApplicationController

  def create
    full_name = repo_params.fetch(:url).sub('https://github.com/', '').strip

    if session[:github_access_token]
      redirect_to repo_assignments_path(full_name)
    else
      # we need the user to connect their github account
      # so stash the repo_full_name so we can redirect
      # them to the repo_path afterwards
      session[:repo_full_name] = full_name
      redirect_to github_token_req_path
    end
  end

  private

  def repo_params
    params.require(:repo).permit(:url)
  end
end
