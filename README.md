# awesome_bot

Verify links in [awesome](status/status.md) projects

![](http://i.giphy.com/urvsFBDfR6N32.gif)

[![Build Status](https://travis-ci.org/dkhamsing/awesome_bot.svg)](https://travis-ci.org/dkhamsing/awesome_bot) [![Tests](https://img.shields.io/badge/tests-circle%20ci-brightgreen.svg)](https://circleci.com/gh/dkhamsing/awesome_bot)
[![Gem Version](https://badge.fury.io/rb/awesome_bot.svg)](https://badge.fury.io/rb/awesome_bot)
[![](https://img.shields.io/badge/awesome-status-brightgreen.svg)](status/status.md)

`awesome_bot` checks for valid URLs in a file, it can be used to [verify pull requests](#validate-pull-requests) updating a README.

## Installation

    $ gem install awesome_bot

## Usage

### Command Line

``` shell
Usage: awesome_bot [file or files]
       awesome_bot [options]
    -f, --files [files]              Comma separated files to check
    -a, --allow [errors]             Status code errors to allow
        --allow-dupe                 Duplicate URLs are allowed
        --allow-ssl                  SSL errors are allowed
        --allow-redirect             Redirected URLs are allowed
        --allow-timeout              URLs that time out are allowed
        --base-url [base url]        Base URL to use for relative links
    -d, --request-delay [seconds]    Set request delay
    -t, --set-timeout [seconds]      Set connection timeout (default: 30)
        --skip-save-results          Skip saving results
    -w, --white-list [urls]          Comma separated URLs to white list
```

- You can check multiple files (comma separated or `*` pattern, look below for details).

- By default, duplicate URLs or any status code other than `200` are flagged as failures.

  - Use option `--allow-dupe` to allow duplicates.
  - Use option `--allow-redirect` to allow redirects.
  - Use option `--allow` to allow specific status code errors.
  - Use option `--white-list` (`-w` for short) to prevent links from being flagged: `-w domain1.com/post/article,domain2.com` white lists `domain1.com/post/article` and all links matching `domain2.com`.

### Examples

```shell
$ awesome_bot README.md
> Checking links in README.md
Links found: 56, 37 unique
  01. https://github.com/sindresorhus/awesome
  02. http://i.giphy.com/urvsFBDfR6N32.gif
  03. https://travis-ci.org/dkhamsing/awesome_bot.svg
# ...
  37. https://github.com/dkhamsing
  Checking URLs: ✓✓✓→?✓→✓→→✓✓→✓✓✓→✓✓✓✓✓✓✓✓✓✓✓→✓✓✓✓✓→✓✓

Issues :-(
> Links
  1. [L007] 301 https://travis-ci.org/dkhamsing/awesome_bot.svg → https://api.travis-ci.org/dkhamsing/awesome_bot.svg
  2. [L008] 302 https://badge.fury.io/rb/awesome_bot → http://rubygems.org/gems/awesome_bot
# ...
> Dupes
  1. [L03] https://github.com/sindresorhus/awesome
  2. [L05] http://i.giphy.com/urvsFBDfR6N32.gif
# ...
```

```shell
$ awesome_bot README.md --allow-dupe --allow-redirect -w rubydoc,giphy
# allow redirects, dupes and white list all links matching rubydoc and giphy

$ awesome_bot README.md,README-zh.md
# check links in 2 files

$ awesome_bot docs/*.md
# check all markdown files in docs/ directory

$ awesome_bot README.md --allow-timeout -t 5
# speed up validation by setting a timeout of 5 seconds per link request and allowing timeouts

$ awesome_bot README.md --allow 403,429
# allow status code errors 403 and 429
# --allow 301 would be similar to --allow-redirect

$ awesome_bot README.md --base-url https://github.com/IDR/idr-notebooks/blob/master/
# will check relative links using the base url provided
```

```shell
(master) $ git branch
* master
(master) $ git checkout -b new-branch
Switched to a new branch 'new-branch'
(new-branch) $ touch new-readme.md && echo 'https://github.com/dkhamsing' >> new-readme.md
(new-branch) $ git add new-readme.md
(new-branch) $ git commit -m 'Testing'
[new-branch ef47336] Testing
 1 file changed, 1 insertion(+)
 create mode 100644 new-readme.md
(new-branch) $ git diff master.. --name-only | grep '.md' | xargs awesome_bot
> Checking links in new-readme.md
Links to check: 1
  1. https://github.com/dkhamsing
Checking URLs: ✓
No issues :-)

Wrote results to ab-results-new-readme.md.json
```

### Docker Examples
If you do not want to install Ruby or it's dependencies you can simply use Docker and Docker image.

Here is the example how you can check the links in your current directory+subdirectories markdown files:
```shell
docker run -ti --rm -v $PWD:/mnt:ro dkhamsing/awesome_bot --white-list "test.com" --allow-dupe --allow-redirect --skip-save-results `find . -name "*.md"`
```

or check links in just in a single file located in `./templates/ubuntu.md`:

```shell
docker run -ti --rm -v $PWD:/mnt:ro dkhamsing/awesome_bot --allow-dupe --allow-redirect --skip-save-results ./templates/ubuntu.md
```

You always need to specify the path to the file so you can not use simply `*.md` but `ls *.md"`:
```shell
docker run -ti --rm -v $PWD:/mnt:ro dkhamsing/awesome_bot --white-list "test.com" --allow-dupe --allow-redirect --skip-save-results `ls *.md`
```

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

## Validate Pull Requests

Does your GitHub README contain a lot of links? `awesome_bot` can help you validate them when a [pull request](https://github.com/dkhamsing/open-source-ios-apps/pull/159) is created (or a commit is pushed). It is used by:

- https://github.com/tiimgreen/github-cheat-sheet
- https://github.com/enaqx/awesome-react
- https://github.com/ziadoz/awesome-php
- https://github.com/vsouza/awesome-ios
- https://github.com/alebcay/awesome-shell
- https://github.com/matteocrippa/awesome-swift

and [more](status/status.md).

Tips

- Use the keyword `[ci skip]` in your commit title/message to skip verification.
- Use [Danger](#danger).

### Travis CI

To use `awesome_bot` with Travis CI, [connect your repo](https://travis-ci.org/) and create a [`.travis.yml` file](https://github.com/ziadoz/awesome-php/blob/master/.travis.yml).

```yml
language: ruby
rvm: 2.4.1
before_script: gem install awesome_bot
script: awesome_bot README.md
```

To turn off email notifications, add the lines below

```yml
notifications:
  email: false
```

In case you want to use the docker image inside Travis CI follow this example which will check broken links in all `*.md` files in your repository:

```yml
sudo: required

services:
  - docker

script:
  # Link Checks
  - docker run -ti --rm -v $PWD:/mnt:ro dkhamsing/awesome_bot --allow-dupe --allow-redirect --skip-save-results `find . -name "*.md"`
```

### More

[CircleCI](https://circleci.com), [Codeship](https://codeship.com/), and [Semaphore CI](https://semaphoreci.com/) support running tests without adding a file to the repo (a public configuration file can however help others contribute).

```
# Codeship
Setup
rvm use 2.4.1 --install
gem install awesome_bot

Test
awesome_bot README.md
```

```
# Semaphore CI
Language: Ruby
Ruby version: 2.4.1
Databases for: don't generate
Setup:
gem install awesome_bot
awesome_bot README.md
```

### Status Badge

[![Build Status](https://travis-ci.org/unixorn/awesome-zsh-plugins.svg)](https://travis-ci.org/unixorn/awesome-zsh-plugins)

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

You can also add a badge for other CI tools, check out [shields.io](https://shields.io/).

### Danger

Integrate `awesome_bot` with [Danger](https://github.com/danger/danger) and have results reported back to the [pull request](https://github.com/vsouza/awesome-ios/pull/1001).

![danger](https://cloud.githubusercontent.com/assets/4723115/17375716/0cdd37cc-5967-11e6-8ae3-829060a786dc.png)

Here's the step in your **Dangerfile**:

```ruby
# Check links
require 'json'
results = File.read 'ab-results-README.md-markdown-table.json'
j = JSON.parse results
if j['error']==true
  fail j['title']
  markdown j['message']
end
```

## Contact

- [github.com/dkhamsing](https://github.com/dkhamsing)
- [twitter.com/dkhamsing](https://twitter.com/dkhamsing)

## License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
