`gem install octokit -v 4.25.1`

require_relative 'parsing'
require_relative 'github_issue_service'

github_service = GithubIssueService.new(ENV['GH_TOKEN'], ENV['GEMFILE_REPOSITORY'])
github_service.download_gemfiles

`gem install bundler -v #{github_service.bundler_version}`

outputs = `bundle _#{github_service.bundler_version}_ outdated --strict`
pp outputs
parsing = Parsing.new(outputs)
pp parsing.to_md
github_service.update_the_issue(parsing.gems_explicit.size, parsing.to_md)
