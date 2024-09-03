# frozen_string_literal: true

require 'cgi'

class Parsing
  LINE_REGEX = /\s\s+/.freeze

  attr_accessor :gems_explicit

  def initialize(output)
    @output = output
    @gems_explicit = []
    @gems_dependencies = []
    extract_data
  end

  def to_md
    <<~MARKDOWN
      #{badge_link}

      `bundle outdated --strict`

      #{to_table}

      <details>
        <summary>Dependencies (#{@gems_dependencies.size})</summary>

        #{to_table_dependencies}
      </details>
    MARKDOWN
  end

  private

  def extract_data
    table = @output.split("\n\n").last
    table = table.split("\n")
    table.shift

    table.each do |line|
      name, current, newest, _requested, groups = line.split(LINE_REGEX)
      parsed_line = { name: name, newest: newest, current: current, groups: groups }
      if parsed_line[:groups]
        @gems_explicit << parsed_line
      else
        @gems_dependencies << parsed_line
      end
    end
  end

  def to_table
    table = +"|Gem|Current|Newest|Groups|\n|---|---|---|---|\n"
    @gems_explicit.each do |gem|
      table << "|#{rubygem_link(gem[:name])}|#{gem[:current]}|#{gem[:newest]}|#{gem[:groups]}|\n"
    end
    table
  end

  def to_table_dependencies
    table = +"|Gem|Current|Newest|\n|---|---|---|\n"
    @gems_dependencies.each do |gem|
      table << "|#{rubygem_link(gem[:name])}|#{gem[:current]}|#{gem[:newest]}|\n"
    end
    table
  end

  def rubygem_link(gem_name)
    "[#{gem_name}](https://rubygems.org/gems/#{gem_name})"
  end

  def badge_link
    puts ENV['GITHUB_WORKFLOW']
    workflow_file = ENV['GITHUB_WORKFLOW'].split('/').detect { |path| path.include?('.yml') }
    # uri = CGI.escape("https://github.com/#{ENV['GEMFILE_REPOSITORY']}/actions/workflows/#{ENV['GITHUB_WORKFLOW']}/badge.svg")
    # "![#{ENV['GITHUB_WORKFLOW']}](#{uri})"
    "[![Outdated Gems](https://github.com/#{ENV['GEMFILE_REPOSITORY']}/actions/workflows/#{workflow_file}/badge.svg)](https://github.com/#{ENV['GEMFILE_REPOSITORY']}/actions/workflows/#{workflow_file})"
  end
end
