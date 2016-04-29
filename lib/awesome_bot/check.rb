require 'awesome_bot/links'
require 'awesome_bot/log'
require 'awesome_bot/output'
require 'awesome_bot/result'
require 'awesome_bot/statuses'

# Check links
module AwesomeBot
  NUMBER_OF_THREADS = 10

  class << self
    def check(content, options=nil, log = Log.new)
      if options.nil?
        white_listed = nil
        skip_dupe = false
        timeout = nil
      else
        white_listed = options['whitelist']
        skip_dupe = options['allowdupe']
        timeout = options['timeout']
      end

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
      total = pad_list r.links.uniq
      r.links.uniq.each_with_index do |u, j|
        log.add "  #{pad_text j + 1, total}. #{u}"
      end

      log.addp 'Checking URLs: ' if r.links.count > 0
      r.status =
        statuses(r.links.uniq, NUMBER_OF_THREADS, timeout) do |s|
          log.addp log_status s
        end
      log.add ''

      return r if !r.white_listing || (r.links_white_listed.count == 0)

      log.addp 'Checking white listed URLs: '
      r.white_listed =
        statuses(r.links_white_listed.uniq, NUMBER_OF_THREADS, nil) do |s|
          log.addp log_status s
        end
      log.add ''

      r
    end # check
  end # class
end
