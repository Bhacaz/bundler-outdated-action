# frozen_string_literal: true

`gem install octokit -v 9.1.0`

require_relative 'parsing'
require_relative 'github_issue_service'

github_service = GithubIssueService.new(ENV['GH_TOKEN'], ENV['GEMFILE_REPOSITORY'])

outputs = `bundle outdated --strict`
parsing = Parsing.new(outputs)
github_service.update_the_issue(parsing.gems_explicit.size, parsing.to_md)
