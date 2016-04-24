require 'awesome_bot/links'
require 'awesome_bot/log'
require 'awesome_bot/result'
require 'awesome_bot/statuses'

# Check links
module AwesomeBot
  NUMBER_OF_THREADS = 10

  STATUS_OK = '✓'
  STATUS_OTHER = '?'
  STATUS_400s = 'x'
  STATUS_REDIRECT = '→'

  class << self
    def log_status(s, log)
      if status_is_redirected? s
        log.addp STATUS_REDIRECT
      elsif s == 200
        log.addp STATUS_OK
      elsif (s > 399 && s < 500)
        log.addp STATUS_400s
      else
        log.addp STATUS_OTHER
      end
    end

    def check(content, white_listed = nil, skip_dupe = false, log = Log.new)
      content = GitHub::Markup.render('README.md', content)
      log.add '> Will allow duplicate links' if skip_dupe

      temp = links_filter(links_find(content))

      r = Result.new(temp, white_listed)
      r.skip_dupe = skip_dupe

      log.add "> White list links matching: #{white_listed.join ', '}" if r.white_listing

      r.dupes = r.links.select { |e| r.links.count(e) > 1 }

      log.addp "Links to check: #{r.links.count}"
      log.addp ", #{r.links_white_listed.count} white listed" if r.white_listing
      uniq = r.links.uniq.count
      log.addp ", #{uniq} unique" if uniq != r.links.count
      log.add ''
      r.links.uniq.each_with_index { |u, j| log.add "  #{j + 1}. #{u}" }

      log.addp 'Checking URLs: ' if r.links.count > 0
      r.status =
        statuses(r.links.uniq, NUMBER_OF_THREADS) do |s|
          log_status s, log
        end
      log.add ''

      return r if !r.white_listing || (r.links_white_listed.count == 0)

      log.addp 'Checking white listed URLs: '
      r.white_listed =
        statuses(r.links_white_listed.uniq, NUMBER_OF_THREADS, true) do |s|
          log_status s, log
        end
      log.add ''

      r
    end # check
  end # class
end
