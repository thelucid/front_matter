# FrontMatter

Smarter YAML front matter parser for Ruby. Parse front matter from a string or file. Fast, reliable and easy to use. Parses YAML front matter by default, but also has support for JSON front matter, with options to set custom delimiters. Inspired by the [gray-matter](https://github.com/jonschlinkert/gray-matter) JavaScript project.

## Features

* **Simple**: a `parse` method accepts a string and returns a parser object that extracts the relevent `data`, `content`, optional `excerpt` and more. Whilst the `stringify` method compiles those elements back down to a single string.
* **Accurate**: better at handling edge cases than front matter parsers that rely on regex for parsing.
* **Fast**: faster than other front matter parsers that use regex for parsing.
* **Flexible**: by default, is capable of parsing [YAML](https://github.com/nodeca/js-yaml) and [JSON](http://en.wikipedia.org/wiki/Json) front matter. Other engines may be added.
* **Extensible**: use custom delimiters, or add support for any language, like [TOML](http://github.com/mojombo/toml), [CoffeeScript](http://coffeescript.org), or [CSON](https://github.com/bevry/cson).
* **Documented**: full API documentation with SDoc (RDoc derivative used by Rails).
* **Tested**: full test suite with 100% coverage, and feature parity with [gray-matter](https://github.com/jonschlinkert/gray-matter).
* **Safe**: designed with untrusted user input in mind.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'front_matter'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install front_matter

## Usage

### Parse

To parse a string or file containing front matter, use the following methods. See API dicumentation for details on what arguments can be passed:

* FrontMatter.parse — new parser from a string.
* FrontMatter.read — new parser from a file.
* FrontMatter.test — test string for front matter.
* FrontMatter.language — extract language from a
  string containing front matter.

### Stringify

To stringify `data`, `content` and optional `excerpt`, using YAML (default) or JSON front matter, use the following methods. See API dicumentation for details on what arguments can be passed:

* FrontMatter.stringify — stringify +data+, +content+ and optional +excerpt+.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thelucid/front_matter.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
