class ProjectsController < ApplicationController
  def create
    repo = project_params.fetch(:url).sub('https://github.com/', '').strip
    redirect_to project_path(repo)
  end

  def show
    repo = params.fetch(:id)
    @issues = GithubRepo.issues(repo, :unassigned)
  end

  private

  def project_params
    params.require(:project).permit(:url)
  end
end
