`gem install octokit`

require_relative 'parsing'
require_relative 'github_issue_service'

p ENV

github_service = GithubIssueService.new(ENV['GH_TOKEN'], ENV['GEMFILE_REPOSITORY'])
github_service.download_gemfiles

`gem install bundler -v #{github_service.bundler_version}`

outputs = `bundle _#{github_service.bundler_version}_ outdated  --only-explicit --strict`
parsing = Parsing.new(outputs)
github_service.update_the_issue(parsing.data.size, parsing.to_md)

# https://help.github.com/en/actions/creating-actions/creating-a-docker-container-action
