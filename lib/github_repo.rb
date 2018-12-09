require 'octokit'

class GithubRepo
  attr_reader :client, :repo

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
  end

  def issues(issue_type)
    options = {
      sort: :updated,
      direction: :desc
    }
    list = client.issues(repo, options.merge(state: :open)).map { |i| struct_from_api_issue(i) }
    case issue_type
    when :unassigned
      list.find_all { |issue| issue.assignees.empty? }
    else
      raise "Unknown issue_type #{issue_type}"
    end
  end

  def contributors
    client.contributors(repo)
  end

  private

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
