# Auth0 Verifier

Verify [Auth0](auth0) JWT token using RS256 with JWKS method.

[![Gem Version](https://img.shields.io/gem/v/auth0-verifier.svg?style=flat-square)][rubygems]

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'auth0-verifier'
```

## Usage

### In Rails using initializer

Create file `config/initializers/auth0.rb` and add:

```rb
Auth0::Verifier.configure do |config|
  config.domain = 'test.auth0.com' # Defaults to ENV variable AUTH0_DOMAIN
  config.audience = 'https://example.com' # Defaults to ENV variable AUTH0_AUDIENCE

  # Optional:
  #
  # config.type = :RS256 # Default RS256 using JWKS
  # config.jwks_url = 'https://test.auth0.com/.well-known/jwks.json' # Defaults to domain
end

```


Verify token:

```rb
Auth0::Verifier.verify('my token')

```

## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby
implementations:

* Ruby 2.3.0
* Ruby 2.4.0
* Ruby 2.5.0
* Ruby 2.6.0

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jpalumickas/auth0-verifier. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## Code of Conduct

Everyone interacting in the Auth0 Verifier project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jpalumickas/auth0-verifier/blob/master/CODE_OF_CONDUCT.md).

## Copyright
Copyright (c) 2019 Justas Palumickas. See [LICENSE][license] for details.

[rubygems]: https://rubygems.org/gems/auth0-verifier
[travis]: https://travis-ci.org/jpalumickas/auth0-verifier

[license]: https://raw.githubusercontent.com/jpalumickas/auth0-verifie/master/LICENSE
[auth0]: https://auth0.com
