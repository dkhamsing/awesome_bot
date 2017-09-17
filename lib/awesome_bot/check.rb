require 'awesome_bot/links'
require 'awesome_bot/net'
require 'awesome_bot/output'
require 'awesome_bot/result'
require 'awesome_bot/github'

# Check links
module AwesomeBot
  class << self
    def check(content, options=nil, number_of_threads=1)
      if options.nil?
        options = {"whitelist" => nil, 'skip_dupe' => nil, 'timeout' => nil, 'base' => nil}
      end
      white_listed = options['whitelist']
      skip_dupe = options['allowdupe']
      timeout = options['timeout']
      base = options['baseurl']

      links = links_filter(links_find(content, base))

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
        statuses(r.links.uniq, number_of_threads, timeout, options) do |s|
          yield log_status s if block_given?
        end
      yield "\n" if block_given?

      return r if !r.white_listing || (r.links_white_listed.count == 0)

      yield 'Checking white listed URLs: ' if block_given?
      r.white_listed =
        statuses(r.links_white_listed.uniq, number_of_threads, nil, options) do |s|
          yield log_status s if block_given?
        end
      yield "\n" if block_given?

      r
    end # check

    def statuses(links, threads, timeout, options = {"delay" => nil, 'github_age' => nil})
      require 'parallel'
      delay = options['delay']
      delay = 0 if delay.nil?
      max_github_age = options['github_age']
      statuses = []
      # return statuses
      Parallel.each(links, in_threads: threads) do |u|
        sleep delay
        begin
          status, headers = net_status u, timeout
          age = github_age(u) if max_github_age !=  nil
          error = nil
          if age != nil and age > max_github_age
            status = -2
          end
        rescue => e
          puts e.backtrace
          status = STATUS_ERROR
          headers = {}
          error = e
        end
        yield status, u, headers if block_given?
        puts error unless error == nil
        statuses.push('url' => u, 'status' => status, 'error' => error, 'headers' => headers)
      end # Parallel

      statuses
    end
  end # class
end
