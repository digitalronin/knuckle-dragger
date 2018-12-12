class AssignmentsController < ApplicationController
  def create
    github(repo_name).assign_issue(assignment_params)
    redirect_to repo_path(repo_name)
  end

  def destroy
    github(repo_name).unassign_issue(assignment_params)
    redirect_to repo_path(repo_name)
  end

  private

  def repo_name
    assignment_params.fetch(:repo)
  end

  def github(repo_name)
    GithubRepo.new(repo_name, session[:github_access_token])
  end

  def assignment_params
    params.require(:assignment).permit(:repo, :issue, :collaborator)
  end
end
