require 'octokit'

class GithubRepo
  attr_reader :client, :repo, :issues

  Issue = Struct.new(:number, :title, :body, :html_url, :state, :assignees, :labels, :updated_at)

  # Waffle.io standard labels for issues
  IN_PROGRESS = 'in progress'
  DONE = 'done'

  def initialize(repo)
    Octokit.configure do |c|
      # c.auto_paginate = true
      c.per_page = 100 # Maximum is 100 (I think)
    end
    @client = Octokit::Client.new()
    @repo = repo
    @issues = fetch_issues
  end

  def contributors
    rtn = client.contributors(repo)
    rtn.is_a?(Enumerable) ? rtn : []
  end

  def unassigned_issues
    issues.find_all {|i| i.assignees == []}
  end

  def issues_assigned_to(name)
    issues.find_all {|i| i.assignees.include?(name)}
  end

  private

  def fetch_issues
    options = {
      sort: :updated,
      direction: :desc
    }
    client.issues(repo, options.merge(state: :open)).map { |i| struct_from_api_issue(i) }
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
