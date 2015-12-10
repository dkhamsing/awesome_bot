# awesome_bot

:rocket: Check for links in [awesome](https://github.com/sindresorhus/awesome) projects

![](http://i.giphy.com/12qq4Em3MVuwJW.gif)

`awesome_bot` checks for valid URLs in a file, it can be used to verify pull requests to update a README with [Travis](#travis).

[![Build Status](https://travis-ci.org/dkhamsing/awesome_bot.svg)](https://travis-ci.org/dkhamsing/awesome_bot)
[![Gem Version](https://badge.fury.io/rb/awesome_bot.svg)](https://badge.fury.io/rb/awesome_bot)

## Installation

Add this line to your application's Gemfile

    gem 'awesome_bot'

And then execute

    $ bundle

Or install it yourself as

    $ gem install awesome_bot

## Usage

### Library

```ruby
irb(main):001:0> require 'awesome_bot'
=> true
irb(main):002:0> c = File.read 'README.md'
=> "..."
irb(main):003:0> AwesomeBot.check c
=> [false, [{"url"=>"http://gph.is/1gU5itl", "status"=>301},..]
# returning false, statuses and dupes if there are errors
# otherwise returning true
```

More information at [rubydoc](http://www.rubydoc.info/gems/awesome_bot/1.0.0).

### Command Line

    awesome_bot <file> [--allow-dupe] [--white-list item1,item2,..]


```shell
$ awesome_bot README.md
Checking links in ../README.md
Links found: 35, 11 unique
  1. https://github.com/sindresorhus/awesome
  2. http://i.giphy.com/12qq4Em3MVuwJW.gif
  3. https://travis-ci.org/dkhamsing/awesome_bot.svg
  4. https://travis-ci.org/dkhamsing/awesome_bot
  5. https://travis-ci.org/
  6. http://gph.is/1gU5itl
  7. https://github.com/dkhamsing
  8. https://twitter.com/dkhamsing
  9. https://github.com/dkhamsing/open-source-ios-apps/pull/159
  10. https://github.com/dkhamsing/open-source-ios-apps/blob/master/.travis.yml
  11. https://codeload.github.com/dkhamsing/awesome_bot/tar.gz/wip
Checking URLs: x✓✓✓x✓✓✓✓✓✓

Issues :-(
> Links
  1. 301 http://gph.is/1gU5itl
  2. 301 https://travis-ci.org/dkhamsing/awesome_bot.svg
> Dupes
  1. https://github.com/sindresorhus/awesome
  2. http://i.giphy.com/12qq4Em3MVuwJW.gif
  3. https://travis-ci.org/dkhamsing/awesome_bot.svg
  4. https://travis-ci.org/dkhamsing/awesome_bot
  5. https://travis-ci.org/
  6. http://gph.is/1gU5itl
  7. https://github.com/dkhamsing
  8. https://twitter.com/dkhamsing
  9. https://github.com/dkhamsing/open-source-ios-apps/pull/159
  10. https://github.com/dkhamsing/open-source-ios-apps/blob/master/.travis.yml
  11. https://codeload.github.com/dkhamsing/awesome_bot/tar.gz/wip
```

```shell
$ awesome_bot README.md --allow-dupe --white-list gph.is,bot.svg
> Checking links in README.md
> Will not check for duplicate links
> White list: gph.is, bot.svg
Links found: 27, 8 white listed, 9 unique
  1. https://github.com/sindresorhus/awesome
  2. http://i.giphy.com/12qq4Em3MVuwJW.gif
  3. https://travis-ci.org/dkhamsing/awesome_bot
  4. https://travis-ci.org/
  5. https://github.com/dkhamsing
  6. https://twitter.com/dkhamsing
  7. https://github.com/dkhamsing/open-source-ios-apps/pull/159
  8. https://github.com/dkhamsing/open-source-ios-apps/blob/master/.travis.yml
  9. https://codeload.github.com/dkhamsing/awesome_bot/tar.gz/wip
Checking URLs: ✓✓✓✓✓✓✓✓✓
No issues :-)
```

## Travis

Use `awesome_bot` with [Travis](https://travis-ci.org/) to validate GitHub [pull requests](https://github.com/dkhamsing/open-source-ios-apps/pull/159).

Example [`.travis.yml` file](https://github.com/dkhamsing/open-source-ios-apps/blob/master/.travis.yml)

```
language: ruby
rvm:
  - 2.2
before_script:
  - gem install awesome_bot
script:
  - awesome_bot README.md
```

## Credits

- `faraday`, `parallel` and [more](awesome_bot.gemspec)
- [giphy](http://gph.is/1gU5itl)

## Contact

- [github.com/dkhamsing](https://github.com/dkhamsing)
- [twitter.com/dkhamsing](https://twitter.com/dkhamsing)

## License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
