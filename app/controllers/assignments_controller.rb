class AssignmentsController < ApplicationController
  def create
    repo = GithubRepo.new(assignment_params.fetch(:repo), session[:github_access_token])
    repo.assign_issue(assignment_params)
  end

  def destroy
    Rails.logger.debug params.inspect
  end

  private

  def assignment_params
    params.require(:assignment).permit(:repo, :issue, :collaborator)
  end
end
