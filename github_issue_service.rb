# frozen_string_literal: true

require 'octokit'

class GithubIssueService
  ISSUE_TITLE = 'Outdated gems'
  def initialize(token, repo)
    @repo = repo
    @client = Octokit::Client.new(access_token: token)
  end

  def update_the_issue(outdated_count, body = nil)
    issue = find_the_issue || create_the_issue
    @client.update_issue(@repo, issue[:number], { title: "#{ISSUE_TITLE} (#{outdated_count})", body: body })
  end

  private

  def find_the_issue
    query = "#{ISSUE_TITLE} repo:#{@repo} is:issue"
    @client.search_issues(query, { page: 1, per_page: 1 })[:items]&.first
  end

  def create_the_issue
    @client.create_issue(@repo, ISSUE_TITLE)
  end
end
