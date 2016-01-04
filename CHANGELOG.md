# awesome_bot

## 0.1.0

- initial version

## 1.0.0

- correct failure logic
- rename `run` to `check`
- isolate cli
- [cli] simply usage, output version
- [gemspec] update
- [travis] simplify

## 1.1.0

- handle bad links
- statuses yields `status`, `url`
- add head option when getting statuses
- [cli] improve output for `--allow-dupe`

# 1.2.0

- move some logic from check to cli
- output status for white listed links
- use `result`
- use `logger`

# 1.2.1

- correct logic for displaying white list status

# 1.3.0

- add `--allow-redirect` option, suggested by [R.I. Pienaar][]
- output `→` as redirect status indicator
- update error logic in statuses

# 1.3.1

- [fix] error with `)` in link parsing, reported by [Halim Qarroum](https://github.com/HQarroum)
- minor improvement to output

# 1.3.2

- [fix] another error with `)` in link parsing, reported by [Julien Bisconti](https://github.com/veggiemonk)

# 1.3.3

- [gemspec] remove uri dependency

# 1.4.0

- add `--allow-timeout` and `--set-timeout` options, suggested by [R.I. Pienaar][]

# 1.5.0

- [output] display url redirect location, by [Colby M. White](https://github.com/colbywhite)
- [output] update logic for number of unique links
- [output] standardize indent
- rename `Result` `rejected` to `links_white_listed` 

## Contact

- [github.com/dkhamsing](https://github.com/dkhamsing)
- [twitter.com/dkhamsing](https://twitter.com/dkhamsing)

[R.I. Pienaar]:https://github.com/ripienaar
