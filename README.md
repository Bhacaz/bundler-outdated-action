# bundler-outdated-action

Use Github Actions to create and update a Github issue with the gems in your project that can be updated.

The result look like this:

---
# [Outdated gems (4)](https://github.com/Bhacaz/bundler-outdated-action/issues/1)

`bundle outdated --strict`

|Gem| Current |Newest|Groups|
|---|---------|---|---|
|[byebug](https://rubygems.org/gems/byebug)| 11.1.1  |11.1.3|development, test|
|[figaro](https://rubygems.org/gems/figaro)| 1.1.1   |1.2.0|default|
|[sidekiq](https://rubygems.org/gems/sidekiq)| 6.0.6   |6.0.7|default|
|[web-console](https://rubygems.org/gems/web-console)| 4.0.1   |4.0.2|development|

---

# To use

1. Create a new workflows in your project (`.github/workflows/outdated_gems.yml`)
2. Create a [Personal access tokens](https://github.com/settings/tokens) with the scope `repo`
3. Add the token in the secrets of your repository with the name `GH_TOKEN`

Example:

```yaml
name: 'Outdated Gems'

on:
  push:
    branches:
      - master

jobs:
  outdated_gems:
    runs-on: ubuntu-latest
    name: Outdated gems
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
      - name: 'Pull outdated gem action script'
        uses: actions/checkout@v4
        with:
          repository: 'Bhacaz/bundler-outdated-action'
          path: 'bundler-outdated-action'
      - name: 'Check outdated gems and update issue'
        run: 'ruby bundler-outdated-action/main.rb'
        env:
          GH_TOKEN: ${{ secrets.GH_TOKEN }}
          GEMFILE_REPOSITORY: ${{ github.repository }}
          GITHUB_WORKFLOW: ${{ github.workflow_ref }}
```
