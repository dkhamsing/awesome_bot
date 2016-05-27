require 'awesome_bot/links'
require 'awesome_bot/net'
require 'awesome_bot/output'
require 'awesome_bot/result'

# Check links
module AwesomeBot
  NUMBER_OF_THREADS = 10

  class << self
    def check(content, options=nil)
      if options.nil?
        white_listed = nil
        skip_dupe = false
        timeout = nil
      else
        white_listed = options['whitelist']
        skip_dupe = options['allowdupe']
        timeout = options['timeout']
      end

      links = links_filter(links_find(content))

      r = Result.new(links, white_listed)
      r.skip_dupe = skip_dupe

      r.dupes = r.links.select { |e| r.links.count(e) > 1 }

      yield "Links to check: #{r.links.count}" if block_given?
      yield ", #{r.links_white_listed.count} white listed" if r.white_listing && block_given?
      uniq = r.links.uniq.count

      yield ", #{uniq} unique" if uniq != r.links.count && block_given?
      yield "\n" if block_given?
      total = pad_list r.links.uniq
      r.links.uniq.each_with_index do |u, j|
        yield "  #{pad_text j + 1, total}. #{u} \n" if block_given?
      end

      yield 'Checking URLs: ' if block_given? && r.links.count > 0
      r.status =
        statuses(r.links.uniq, NUMBER_OF_THREADS, timeout) do |s|
          yield log_status s if block_given?
        end
      yield "\n" if block_given?

      return r if !r.white_listing || (r.links_white_listed.count == 0)

      yield 'Checking white listed URLs: ' if block_given?
      r.white_listed =
        statuses(r.links_white_listed.uniq, NUMBER_OF_THREADS, nil) do |s|
          yield log_status s if block_given?
        end
      yield "\n" if block_given?

      r
    end # check
  end # class
end
