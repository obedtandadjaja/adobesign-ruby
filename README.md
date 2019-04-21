# AdobeSign Ruby Library - Alpha
Ruby library for the Adobesign API v5.

## Installation
You don't need this source code unless you want to modify the gem. If you just want to use the package, just run:

```
gem install adobesign-ruby
```

If you want to build the gem from source:

```
gem build adobesign-ruby.gemspec
```

### Requirements
* Ruby 2.0+

### Bundler
If you are installing via bundler, you should be sure to use the https rubygems source in your Gemfile, as any gems fetched over http could potentially be comprimised in transit and alter the code of gems fetched securely over https:

```
source 'https://rubygems.org'

gem 'rails'
gem 'adobesign-ruby'
```
