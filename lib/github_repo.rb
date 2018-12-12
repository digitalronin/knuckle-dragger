require 'octokit'

class GithubRepo
  attr_reader :full_name, :issues, :collaborators

  Issue = Struct.new(:number, :title, :body, :html_url, :state, :assignees, :labels, :updated_at)

  # Waffle.io standard labels for issues
  IN_PROGRESS = 'in progress'
  DONE = 'done'

  def initialize(full_name, access_token)
    Octokit.configure do |c|
      # c.auto_paginate = true
      c.per_page = 100 # Maximum is 100 (I think)
    end
    @client = Octokit::Client.new(access_token: access_token)
    @full_name = full_name
    @issues = fetch_issues
    @collaborators = fetch_collaborators
  end

  def unassigned_issues
    issues.find_all {|i| i.assignees == []}
  end

  def issues_assigned_to(name)
    issues.find_all {|i| i.assignees.include?(name)}
  end

  def assign_issue(params)
    assignees = [params.fetch(:collaborator)]
    number = params.fetch(:issue)
    @client.add_assignees(full_name, number, assignees)
  end

  private

  def fetch_issues
    options = {
      sort: :updated,
      direction: :desc,
      state: :open
    }
    @client.issues(full_name, options).map { |i| struct_from_api_issue(i) }
  end

  def fetch_collaborators
    rtn = @client.collaborators(full_name)
    rtn.is_a?(Enumerable) ? rtn : []
  end

  def struct_from_api_issue(i)
    Issue.new(
      i.number,
      i.title,
      i.body,
      i.html_url,
      i.state,
      i.assignees.map(&:login),
      i.labels.map(&:name),
      i.updated_at
    )
  end
end
