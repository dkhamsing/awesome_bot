# awesome_bot

:rocket: Check for links in [awesome](https://github.com/sindresorhus/awesome) projects

![](http://i.giphy.com/urvsFBDfR6N32.gif)

`awesome_bot` checks for valid URLs in a file, it can be used to verify pull requests updating a README with [Travis](#travis).

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
irb(main):003:0> r = AwesomeBot.check c
=> #<AwesomeBot::Result:0x007fdde39f4408 @links=...>
# AwesomeBot Result with success, statuses_issues, dupes and more
irb(main):004:0> puts r.success ? 'No errors' : ':-('
:-(
```

More information at [rubydoc](http://www.rubydoc.info/gems/awesome_bot).

### Command Line

    awesome_bot <file> [--allow-dupe] [--allow-redirect] [--white-list item1,item2,..]

```shell
$ awesome_bot README.md
> Checking links in README.md
Links found: 46, 14 unique
  1. https://github.com/sindresorhus/awesome
  2. http://i.giphy.com/12qq4Em3MVuwJW.gif
  3. https://travis-ci.org/dkhamsing/awesome_bot.svg
  4. https://travis-ci.org/dkhamsing/awesome_bot
  5. https://badge.fury.io/rb/awesome_bot.svg
  6. https://badge.fury.io/rb/awesome_bot
  7. http://www.rubydoc.info/gems/awesome_bot
  8. https://travis-ci.org/
  9. http://gph.is/1gU5itl
  10. https://github.com/dkhamsing
  11. https://twitter.com/dkhamsing
  12. https://github.com/dkhamsing/open-source-ios-apps/pull/159
  13. https://github.com/dkhamsing/open-source-ios-apps/blob/master/.travis.yml
  14. https://codeload.github.com/dkhamsing/awesome_bot/tar.gz/wip
Checking URLs: ✓→→x→→✓✓✓✓x✓✓✓

Issues :-(
> Links
1. 302 https://badge.fury.io/rb/awesome_bot.svg
2. 302 https://badge.fury.io/rb/awesome_bot
3. 202 http://www.rubydoc.info/gems/awesome_bot
4. 301 http://gph.is/1gU5itl
5. 301 https://travis-ci.org/dkhamsing/awesome_bot.svg
6. 404 https://codeload.github.com/dkhamsing/awesome_bot/tar.gz/wip
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
$ awesome_bot README.md --allow-dupe --white-list fury,gph.is,rubydoc,travis,codeload
> Checking links in README.md
> Will allow duplicate links
> White list: fury, gph.is, rubydoc, travis, codeload
Links found: 20, 33 white listed
  1. https://github.com/sindresorhus/awesome
  2. http://i.giphy.com/12qq4Em3MVuwJW.gif
  3. https://github.com/dkhamsing
  4. https://twitter.com/dkhamsing
  5. https://github.com/dkhamsing/open-source-ios-apps/pull/159
Checking URLs: ✓✓✓✓✓
Checking white listed URLs: →x→→✓→✓x✓

> White listed:
  1. 301: http://gph.is/1gU5itl
  2. 202: http://www.rubydoc.info/gems/awesome_bot
  3. 302: https://badge.fury.io/rb/awesome_bot
  4. 302: https://badge.fury.io/rb/awesome_bot.svg
  5. 200: https://travis-ci.org/dkhamsing/awesome_bot
  6. 301: https://travis-ci.org/dkhamsing/awesome_bot.svg
  7. 200: https://travis-ci.org/
  8. 404: https://codeload.github.com/dkhamsing/awesome_bot/tar.gz/wip
  9. 200: https://github.com/dkhamsing/open-source-ios-apps/blob/master/.travis.yml
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

`awesome_bot` is used by the following projects:

- https://github.com/prakhar1989/awesome-courses
- https://github.com/matteocrippa/awesome-swift
- https://github.com/iCHAIT/awesome-osx
- https://github.com/vsouza/awesome-ios
- https://github.com/ellisonleao/magictools
- https://github.com/christian-bromann/awesome-selenium
- https://github.com/sotayamashita/awesome-css
- https://github.com/MakinGiants/awesome-mobile-dev

## Credits

- `faraday`, `parallel` and [more](awesome_bot.gemspec)
- [giphy](http://gph.is/XM6gMT)

## Contact

- [github.com/dkhamsing](https://github.com/dkhamsing)
- [twitter.com/dkhamsing](https://twitter.com/dkhamsing)

## License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
