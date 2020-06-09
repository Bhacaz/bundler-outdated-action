class Parsing

  VALUES_REGEX = /\*\s(.+)\s\(.+?\s(.+?),.+?\s(.+?)\).+\"(.+)\"/.freeze

  attr_accessor :data

  def initialize(output)
    @output = output
    @data = extract_data
  end

  def to_md
    table = +"|Gem|Installed|Newest|Groups|\n|---|---|---|---|\n"
    @data.each do |gem|
      table << "|#{rubygem_link(gem[:name])}|#{gem[:installed]}|#{gem[:newest]}|#{gem[:groups]}|\n"
    end
    <<~MARKDOWN
      #{badge_link}

      `bundle outdated  --only-explicit --strict`

      #{table}
    MARKDOWN
  end

  private

  def extract_data
    gem_line = []
    @output.split("\n").each do |line|
      gem_line << value_from_line(line) if line.include?('*')
    end
    @data = gem_line
  end

  def value_from_line(line)
    name, newest, installed, groups = line.match(VALUES_REGEX).captures
    { name: name, newest: newest, installed: installed, groups: groups }
  end

  def rubygem_link(gem_name)
    "[#{gem_name}](https://rubygems.org/gems/#{gem_name})"
  end

  def badge_link
    "![#{ENV['GITHUB_WORKFLOW']}](https://github.com/#{ENV['GEMFILE_REPOSITORY']}/workflows/#{ENV['GITHUB_WORKFLOW']}/badge.svg)"
  end
end
