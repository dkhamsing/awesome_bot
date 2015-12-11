require 'awesome_bot/links'
require 'awesome_bot/result'
require 'awesome_bot/statuses'

# Check links
module AwesomeBot
  NUMBER_OF_THREADS = 10

  STATUS_OK = '✓'
  STATUS_OTHER = 'x'

  class << self
    def check(content, white_listed = nil, skip_dupe = false, verbose = false)
      puts '> Will allow duplicate links' if skip_dupe && verbose

      temp = links_filter(links_find(content))

      r = Result.new(temp, white_listed)
      r.skip_dupe = skip_dupe

      puts "> White list: #{white_listed.join ', '}" if
        r.white_listing && verbose

      r.dupes = r.links.select { |e| r.links.count(e) > 1 } unless skip_dupe

      if verbose
        print "Links found: #{r.links.count}"
        print ", #{r.rejected.count} white listed" if r.white_listing
        unless skip_dupe
          print ", #{r.links.uniq.count} unique" if r.dupes.count > 0
        end
        puts ''
        r.links.uniq.each_with_index { |u, j| puts "  #{j + 1}. #{u}" }
      end

      print 'Checking URLs: ' if verbose && (r.links.count > 0)
      r.status =
        statuses(r.links.uniq, NUMBER_OF_THREADS) do |s|
          print(s == 200 ? STATUS_OK : STATUS_OTHER) if verbose
        end
      puts '' if verbose

      return r if !r.white_listing || (r.rejected.count > 0)

      print 'Checking white listed URLs: ' if verbose
      r.white_listed =
        statuses(r.rejected.uniq, NUMBER_OF_THREADS, true) do |s|
          print(s == 200 ? STATUS_OK : STATUS_OTHER) if verbose
        end
      puts '' if verbose

      r
    end # run
  end # class
end
