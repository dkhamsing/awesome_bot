require 'awesome_bot/links'
require 'awesome_bot/net'
require 'awesome_bot/output'
require 'awesome_bot/result'

# Check links
module AwesomeBot
  class << self
    def check(content, options=nil, number_of_threads=1)
      if options.nil?
        white_list = nil
        allow_dupe = false
        timeout = nil
        delay = 0
        base = nil
        markdown = nil
      else
        white_list = options['white_list']
        allow_dupe = options['allow_dupe']
        timeout = options['timeout']
        delay = options['delay']
        delay = 0 if delay.nil?
        base = options['baseurl']
        markdown = options['markdown']
      end

      links = links_filter(links_find(content, base))

      r = Result.new(links, white_list)
      r.allow_dupe = allow_dupe

      r.validate =
        if markdown.nil?
          []
        else
          v = content.scan /\[.*\] \(http.*\)/

          if block_given?
            yield "Validating Markdown: "
            yield v.count==0 ? STATUS_OK : STATUS_400s
            yield "\n"
          end

          v
        end

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

      head = false

      yield 'Checking URLs: ' if block_given? && r.links.count > 0
      r.status =
        statuses(r.links.uniq, number_of_threads, timeout, head, delay) do |s|
          yield log_status s if block_given?
        end
      yield "\n" if block_given?

      return r if !r.white_listing || (r.links_white_listed.count == 0)

      yield 'Checking white listed URLs: ' if block_given?
      r.white_listed =
        statuses(r.links_white_listed.uniq, number_of_threads, nil, head, delay) do |s|
          yield log_status s if block_given?
        end
      yield "\n" if block_given?

      r
    end # check
  end # class
end
