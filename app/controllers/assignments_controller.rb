class AssignmentsController < ApplicationController
  def create
    repo_name = assignment_params.fetch(:repo)
    github = GithubRepo.new(repo_name, session[:github_access_token])
    github.assign_issue(assignment_params)
    redirect_to project_path(repo_name)
  end

  def destroy
    Rails.logger.debug params.inspect
  end

  private

  def assignment_params
    params.require(:assignment).permit(:repo, :issue, :collaborator)
  end
end
