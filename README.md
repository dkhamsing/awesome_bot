# awesome_bot

Verify links in [awesome](https://github.com/sindresorhus/awesome) projects

![](http://i.giphy.com/urvsFBDfR6N32.gif)

[![Build Status](https://travis-ci.org/dkhamsing/awesome_bot.svg)](https://travis-ci.org/dkhamsing/awesome_bot)
[![Gem Version](https://badge.fury.io/rb/awesome_bot.svg)](https://badge.fury.io/rb/awesome_bot)
[![](https://img.shields.io/badge/awesome-status-brightgreen.svg)](status.md)

`awesome_bot` checks for valid URLs in a file, it can be used to [verify pull requests](#validate-pull-requests) updating a README.

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
irb(main):002:0> content = File.read 'README.md'
=> "..."
irb(main):003:0> result = AwesomeBot.check content
=> #<AwesomeBot::Result:0x007fdde39f4408 @links=...>
# AwesomeBot Result with success, statuses_issues, dupes and more
irb(main):004:0> puts result.success ? 'No errors' : ':-('
:-(
```

More information at [rubydoc](http://www.rubydoc.info/gems/awesome_bot).

### Command Line

    awesome_bot <file> [--allow-dupe] [--allow-redirect] [--allow-timeout] [--set-timeout d] [--white-list item1,item2,..]
      file             Path to file, required as first argument
      --allow-dupe     Duplicate URLs are allowed 
      --allow-redirect Redirected URLs are allowed
      --allow-timeout  URLs that time out are allowed
      --set-timeout    Set connection timeout (seconds)
      --white-list     Comma separated URLs/domains to white list

By default, `awesome_bot` flags duplicates and URL redirects.

- Use option `--allow-dupe` to allow duplicates.
- Use option `--allow-redirect` to all redirects. 
- You can also white list specific links that will not be flagged (for dupe or redirect). `--white-list domain1.com/post/article,domain2.com` white lists `domain1.com/post/article` and all links matching `domain2.com`.

### Examples

```shell
$ awesome_bot README.md
> Checking links in README.md
Links found: 56, 53 unique
  1. https://github.com/sindresorhus/awesome
  2. http://i.giphy.com/urvsFBDfR6N32.gif
  3. https://travis-ci.org/dkhamsing/awesome_bot.svg
  ...
  53. https://twitter.com/dkhamsing
Checking URLs: ✓x→✓✓✓✓→→✓→✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓→✓✓✓✓✓✓✓✓

Issues :-(
> Links
  1. 202 http://www.rubydoc.info/gems/awesome_bot
  2. 301 http://rubygems.org/gems/awesome_bot → https://rubygems.org/gems/awesome_bot
  3. 302 https://badge.fury.io/rb/awesome_bot.svg → https://d25lcipzij17d.cloudfront.net/badge.svg?id=rb&type=6&v=1.4.0&x2=0
  4. 302 https://badge.fury.io/rb/awesome_bot → http://rubygems.org/gems/awesome_bot
  5. 301 https://travis-ci.org/dkhamsing/awesome_bot.svg → https://api.travis-ci.org/dkhamsing/awesome_bot.svg
  6. 301 http://gph.is/XM6gMT → http://giphy.com/gifs/urvsFBDfR6N32
> Dupes
  1. https://github.com/sindresorhus/awesome
  2. https://github.com/veggiemonk/awesome-docker
  3. https://github.com/dotfiles/dotfiles.github.com  
```

```shell
$ awesome_bot README.md --allow-dupe --white-list fury,rubydoc,travis,codeload,gems,giphy,gph
> Checking links in README.md
> Will allow duplicate links
> White list links matching: fury, rubydoc, travis, codeload, gems, giphy, gph
Links found: 51, 23 white listed, 42 unique
  1. https://github.com/sindresorhus/awesome
  2. https://twitter.com/dkhamsing
  ...
Checking URLs: ✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓
Checking white listed URLs: →→✓x✓✓✓→✓✓→→→

> White listed:
  1. 301 http://rubygems.org/gems/awesome_bot → https://rubygems.org/gems/awesome_bot
  2. 301 http://gph.is/XM6gMT → http://giphy.com/gifs/urvsFBDfR6N32
  3. 200 http://i.giphy.com/urvsFBDfR6N32.gif
  ...

No issues :-)
```

## Validate Pull Requests

`awesome_bot` can help you validate GitHub [pull requests](https://github.com/dkhamsing/open-source-ios-apps/pull/159), it is used by

- https://github.com/tiimgreen/github-cheat-sheet
- https://github.com/vinta/awesome-python
- https://github.com/enaqx/awesome-react
- https://github.com/vsouza/awesome-ios
- https://github.com/alebcay/awesome-shell
- https://github.com/matteocrippa/awesome-swift

and [more](status.md).


### Travis CI

To use `awesome_bot` with Travis CI, [connect your repo](https://travis-ci.org/) and create a [`.travis.yml` file](https://github.com/dkhamsing/open-source-ios-apps/blob/master/.travis.yml).

```yml
language: ruby
rvm: 2.2
before_script: gem install awesome_bot
script: awesome_bot README.md
```

To turn off email notifications, add the lines below

```yml
notifications:
  email: false
```

### Circle CI

If you prefer Circle CI, it'll work too. [Connect your repo](https://circleci.com/) and create a [`circle.yml` file](https://github.com/tmcw/awesome-geojson).

```yml
machine:
  ruby:
    version: 2.2.0
test:
  pre:
    - gem install awesome_bot
  override:
    - awesome_bot README.md
```

### Status Badge

[![Build Status](https://travis-ci.org/unixorn/awesome-zsh-plugins.png)](https://travis-ci.org/unixorn/awesome-zsh-plugins)

To add the Travis CI build status badge above to your project, use the following code

```
[![Build Status](https://travis-ci.org/<username>/<project>.svg)](https://travis-ci.org/<username>/<project>)

i.e.
[![Build Status](https://travis-ci.org/dkhamsing/awesome_bot.svg?branch=master)](https://travis-ci.org/dkhamsing/awesome_bot)
```

As it happens, the default code snippet provided contain a redirect so adding a badge could fail your status :sob:.. one way to fix this is to white list `travis-ci`, i.e.

```
- awesome_bot README.md --white-list travis-ci
```

[![Circle CI](https://circleci.com/gh/dkhamsing/awesome_bot.svg?style=svg)](https://circleci.com/gh/dkhamsing/awesome_bot)

To add the Circle CI build status badge above to your project, use the following code

```
[![Circle CI](https://circleci.com/gh/<username>/<project>.svg?style=svg)](https://circleci.com/gh/<username>/<project>)

i.e.
[![Circle CI](https://circleci.com/gh/dkhamsing/awesome_bot.svg?style=svg)](https://circleci.com/gh/dkhamsing/awesome_bot)
```

## Credits

- [`faraday` and `parallel`](awesome_bot.gemspec)
- [giphy](http://gph.is/XM6gMT)

## Contact

- [github.com/dkhamsing](https://github.com/dkhamsing)
- [twitter.com/dkhamsing](https://twitter.com/dkhamsing)

## License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
