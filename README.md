# Datura

Welcome to this temporary documentation for Datura, a gem dedicated to transforming and posting data sources from CDRH projects.  This gem is intended to be used with a "data repository" containing TEI, VRA, CSVs, and more.

## Local Development


Add this to your data repo's Gemfile:

```
source 'https://rubygems.org'

gemspec path: '/path/to/local/datura/repo'
```

Then in your repo you can run:

```
bundle install
```

And if that doesn't seem like it's working, run this from the datura gem:

```
bundle exec rake install
```

then from the data repo:

```
gem install --local path/to/local/datura/pkg/datura-0.1.0.gem
```

Test it out by running the `about` command to view all your options:

```
about
```

To set up a brand new data repo run:

```
setup
```

## Tests

```
bundle install
rake test
```
