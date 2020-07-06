# bundler-outdated-action

Use Github Actions to create and update a Github issue with the gems in your project that can be updated.

The result look like this:

---
# [Outdated gems (4)](https://github.com/Bhacaz/bundler-outdated-action/issues/1)

`bundle outdated  --only-explicit --strict`

|Gem|Installed|Newest|Groups|
|---|---|---|---|
|[byebug](https://rubygems.org/gems/byebug)|11.1.1|11.1.3|development, test|
|[figaro](https://rubygems.org/gems/figaro)|1.1.1|1.2.0|default|
|[sidekiq](https://rubygems.org/gems/sidekiq)|6.0.6|6.0.7|default|
|[web-console](https://rubygems.org/gems/web-console)|4.0.1|4.0.2|development|


_Last update: 2020-06-04 15:23:14 UTC_

---

# To use

1. Create a new workflows in your project (`.github/workflows/outdated_gems.yml`)
2. Use the example below and change the `ruby-version` for the one your project use
3. Create a [Personal access tokens](https://github.com/settings/tokens) with the scope `repo`
4. Add the token in the secrets of your repository with the name `GH_TOKEN`

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
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '2.7.0'
      - name: 'Pull outdated gem action script'
        uses: actions/checkout@v2
        with:
          repository: 'Bhacaz/bundler-outdated-action'
      - name: 'Check outdated gems'
        run: 'ruby main.rb'
        env:
          GH_TOKEN: ${{ secrets.GH_TOKEN }}
          GEMFILE_REPOSITORY: ${{ github.repository }} 
```
