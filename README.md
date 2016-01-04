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

    awesome_bot <file> [--allow-dupe] [--allow-redirect] [--allow-timeout] [--set-timeout d] [--white-list item1,item2,..]
      file             Path to file
      --allow-dupe     Duplicates URLs are allowed URLs
      --allow-redirect Redirected URLs are allowed
      --allow-timeout  URLs that time out are allowed
      --set-timeout    Set connection timeout (seconds)
      --white-list     Comma separated URLs to white list

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
> White list: fury, rubydoc, travis, codeload, gems, giphy, gph
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

1. https://github.com/vinta/awesome-python
- https://github.com/prakhar1989/awesome-courses
- https://github.com/ripienaar/free-for-dev
- https://github.com/vsouza/awesome-ios
- https://github.com/caesar0301/awesome-public-datasets
- https://github.com/matteocrippa/awesome-swift
- https://github.com/iCHAIT/awesome-osx
- https://github.com/rosarior/awesome-django
- https://github.com/ellisonleao/magictools
- https://github.com/JStumpp/awesome-android
- https://github.com/dariubs/GoBooks
- https://github.com/arslanbilal/git-cheat-sheet
- https://github.com/chentsulin/awesome-graphql
- https://github.com/fasouto/awesome-dataviz
- https://github.com/RichardLitt/awesome-conferences
- https://github.com/caesar0301/awesome-pcaptools
- https://github.com/matiassingers/awesome-readme
- https://github.com/stefanbuck/awesome-browser-extensions-for-github
- https://github.com/afonsopacifer/awesome-flexbox
- https://github.com/HQarroum/awesome-iot
- https://github.com/filipelinhares/awesome-slack
- https://github.com/notthetup/awesome-webaudio
- https://github.com/ipfs/awesome-ipfs
- https://github.com/brunopulis/awesome-a11y
- https://github.com/ramitsurana/awesome-kubernetes
- https://github.com/christian-bromann/awesome-selenium
- https://github.com/benoitjadinon/awesome-xamarin
- https://github.com/vinkla/awesome-fuse
- https://github.com/wfhio/awesome-job-boards
- https://github.com/sotayamashita/awesome-css
- https://github.com/MakinGiants/awesome-mobile-dev
- https://github.com/unixorn/awesome-zsh-plugins
- https://github.com/vredniy/awesome-newsletters
- https://github.com/unixorn/git-extra-commands
- https://github.com/deanhume/typography
- https://github.com/dotfiles/dotfiles.github.com
- https://github.com/veggiemonk/awesome-docker

## Credits

- [`faraday` and `parallel`](awesome_bot.gemspec)
- [giphy](http://gph.is/XM6gMT)

## Contact

- [github.com/dkhamsing](https://github.com/dkhamsing)
- [twitter.com/dkhamsing](https://twitter.com/dkhamsing)

## License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
