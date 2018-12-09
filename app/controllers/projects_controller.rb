class ProjectsController < ApplicationController

  MAX_CONTRIBUTORS = 10

  def create
    repo = project_params.fetch(:url).sub('https://github.com/', '').strip
    redirect_to project_path(repo)
  end

  def show
    repo = params.fetch(:id)
    gh = GithubRepo.new(repo)
    @issues = gh.issues(:unassigned)
    @contributors = gh.contributors.take(MAX_CONTRIBUTORS)
  end

  private

  def project_params
    params.require(:project).permit(:url)
  end
end
