# awesome_bot changelog

Changes by [Daniel Khamsing][] unless otherwise noted.

# 1.20.0

- [cli] delay: change to use float by [Jonathan Lai](https://github.com/agsdot)
- [gem] update `parallel`, `rspec` to latest

# 1.19.1

- [gem] update `parallel`, `rspec`, `rspec_junit_formatter` to latest

# 1.19.0

- [parse] handle javadoc links by [Davide Angelocola](https://github.com/dfa1)

# 1.18.0

- [parse] stricter parsing of relative urls by [Mat Moore](https://github.com/MatMoore)

# 1.17.2

- [cli] output version by [Budh Ram Gurung](https://github.com/budhrg)
- [gem] update `parallel` to version 1.12.0

# 1.17.1

- [parse] fix Markdown link issue by [Richard Littauer](https://github.com/RichardLitt)

# 1.17.0

- support basic http authentication by [Bill O'Neill](https://github.com/woneill)

# 1.16.1

- update dependencies

# 1.16.0

- add `--base-url` option (check markdown relative links)

# 1.15.0

- add `--skip-save-results` option

# 1.14.0

- add support for request delay

# 1.13.10

- [parse] fix another wikipedia parsing issue

# 1.13.9

- [parse] fix another regression introduced in 1.13.7

# 1.13.8

- [parse] fix regression introduced in 1.13.7

# 1.13.7

- [parse] support wikipedia links with parentheses

# 1.13.6

- handle incomplete redirect

# 1.13.5

- fix header encoding

# 1.13.4

- cleanup `-1` error in markdown table
- isolate `write`
- display number of links in markdown table results

# 1.13.3

- add markdown results table artifacts to use with [`danger`](https://github.com/danger/danger)

# 1.13.2

- correct `redirect` in filtered issues

# 1.13.1

- add `error` (and dupes) to filtered issues

# 1.13.0

- add filtered issues artifacts that can be used to [generate a report](https://github.com/dkhamsing/awesome_bot/issues/95) (this changes an internal `output` format)

# 1.12.1

- handle invalid byte sequence, reported by [Manu Zhang](https://github.com/manuzhang)

# 1.12.0

- add `allow` option to allow specific error status codes, i.e. `--allow 301` or `--allow 403,429`

# 1.11.0

- [net] set `awesome_bot` user agent
- pretty print `json` file
- include `all` links status in results

# 1.10.0

- add `allow-ssl` option, suggested by [Joe Block](https://github.com/unixorn)

# 1.9.1

- [fix] url redirect location encoding, reported by [@hoppfrosch](https://github.com/hoppfrosch)

# 1.9.0

- [cli] support checking multiple files (comma separated or `*` pattern  i.e. `docs/*.md`), suggested by [Sota Yamashita](https://github.com/sotayamashita)
- [cli] use `optparse`

# 1.8.5

- [fix] request errors (make `get` requests), reported by [Richard Littauer](https://github.com/RichardLitt)

# 1.8.4

- [fix] parsing links with colon
- [fix] parsing links separated by comma

# 1.8.3

- restore `head` request option
- rename `net`
- [cli] rename ab-results.json
- [status] yield `headers` (library usage)
- [gem] update `parallel` dependency to `1.8`

# 1.8.2

- [output] add link line number for dupes
- [fix] output line of link default value, reported by [Julien Bisconti][]
- write `json` results file
- isolate and cleanup

# 1.8.1

- [output] show link line number, suggested by [Daniel Gomez Rico](https://github.com/danielgomezrico)
- [output] improve enumeration with padding
- set default open link timeout to 30 seconds

# 1.8.0

- remove `faraday`
- [fix] parse links with commas (url encode), reported by [Kishan Bagaria](https://github.com/KishanBagaria)

# 1.7.1

- [fix] parse issues with links in `adoc` files, reported by [Ibragimov Ruslan](https://github.com/IRus)

# 1.7.0

- [cli] invalid options error
-	[output] improve

# 1.6.0

- [cli] improve argument error
- [output] update status using `x` for 400s error code and `?` for other
- [output] clarify white listing

# 1.5.1

- [fix] link parsing error with markdown badge
- improve code, suggested by [Colby M. White][]

# 1.5.0

- [output] display url redirect location, by [Colby M. White][]
- [output] update logic for number of unique links
- [output] standardize indent
- rename `Result` `rejected` to `links_white_listed`

# 1.4.0

- add `--allow-timeout` and `--set-timeout` options, suggested by [R.I. Pienaar][]

# 1.3.3

- [gemspec] remove uri dependency

# 1.3.2

- [fix] another error with `)` in link parsing, reported by [Julien Bisconti][]

# 1.3.1

- [fix] error with `)` in link parsing, reported by [Halim Qarroum](https://github.com/HQarroum)
- minor improvement to output

# 1.3.0

- add `--allow-redirect` option, suggested by [R.I. Pienaar][]
- output `→` as redirect status indicator
- update error logic in statuses

# 1.2.1

- correct logic for displaying white list status

# 1.2.0

- move some logic from check to cli
- output status for white listed links
- use `result`
- use `logger`

# 1.1.0

- handle bad links
- statuses yields `status`, `url`
- add head option when getting statuses
- [cli] improve output for `--allow-dupe`

# 1.0.0

- correct failure logic
- rename `run` to `check`
- isolate cli
- [cli] simply usage, output version
- [gemspec] update
- [travis] simplify

# 0.1.0

- initial version

## Contact

- [Daniel Khamsing][]

[Daniel Khamsing]:https://github.com/dkhamsing
[Colby M. White]:https://github.com/colbywhite
[Julien Bisconti]:https://github.com/veggiemonk
[R.I. Pienaar]:https://github.com/ripienaar
