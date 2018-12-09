class ProjectsController < ApplicationController
  def create
    repo = project_params.fetch(:url).sub('https://github.com/', '').strip
    @issues = GithubRepo.issues(repo, :unassigned)
  end

  def index
    render :create
  end

  private

  def project_params
    params.require(:project).permit(:url)
  end
end
