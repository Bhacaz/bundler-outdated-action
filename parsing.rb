class Parsing
  EXPLICIT_REGEX = /\*\s(.+)\s\(.+?\s(.+?),.+?\s(.+?)\).+\"(.+)\"/.freeze
  DEPENDENCIES_REGEX = /\*\s(.+)\s\(.+?\s(.+?),.+?\s(.+?)\)/.freeze

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
    @output.split("\n").each do |line|
      if line.include?('*')
        parsed_line = value_from_line(line)
        if parsed_line[:groups]
          @gems_explicit << parsed_line
        else
          @gems_dependencies << parsed_line
        end
      end
    end
  end

  def value_from_line(line)
    if line.include?('groups')
      name, newest, installed, groups = line.match(EXPLICIT_REGEX).captures
    else
      name, newest, installed, groups = line.match(DEPENDENCIES_REGEX).captures
    end
    { name: name, newest: newest, installed: installed, groups: groups }
  end

  def to_table
    table = +"|Gem|Installed|Newest|Groups|\n|---|---|---|---|\n"
    @gems_explicit.each do |gem|
      table << "|#{rubygem_link(gem[:name])}|#{gem[:installed]}|#{gem[:newest]}|#{gem[:groups]}|\n"
    end
    table
  end

  def to_table_dependencies
    table = +"|Gem|Installed|Newest|\n|---|---|---|\n"
    @gems_dependencies.each do |gem|
      table << "|#{rubygem_link(gem[:name])}|#{gem[:installed]}|#{gem[:newest]}|\n"
    end
    table
  end

  def rubygem_link(gem_name)
    "[#{gem_name}](https://rubygems.org/gems/#{gem_name})"
  end

  def badge_link
    uri = URI.encode("https://github.com/#{ENV['GEMFILE_REPOSITORY']}/workflows/#{ENV['GITHUB_WORKFLOW']}/badge.svg")
    "![#{ENV['GITHUB_WORKFLOW']}](#{uri})"
  end
end
