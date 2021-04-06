
require 'octokit'

class GithubIssueService
  ISSUE_TITLE = 'Outdated gems'
  def initialize(token, repo)
    @repo = repo
    @client = Octokit::Client.new(access_token: token)
  end

  def download_gemfiles
    %w[Gemfile Gemfile.lock].each do |gemfile_path|
      content = @client.content(@repo, { path: gemfile_path })[:content]
      File.write(gemfile_path, Base64.decode64(content))
    end
  end

  def bundler_version
    @bundler_version ||= begin
      file = File.open('Gemfile.lock', 'r')
      version = file.each_line.to_a.last.strip
      file.close
      version
    end
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
