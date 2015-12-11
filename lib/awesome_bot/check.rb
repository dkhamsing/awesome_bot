require 'awesome_bot/links'
require 'awesome_bot/statuses'
require 'awesome_bot/white_list'

# Check links
module AwesomeBot
  NUMBER_OF_THREADS = 10

  STATUS_OK = '✓'
  STATUS_OTHER = 'x'

  class << self
    def check(content, white_listed = nil, skip_dupe = false, verbose = false)
      dupe_success = skip_dupe

      puts '> Will allow duplicate links' if skip_dupe && verbose

      white_listing = !white_listed.nil?
      puts "> White list: #{white_listed.join ', '}" if white_listing && verbose

      links = links_filter(links_find(content))

      if white_listing
        rejected, links = links.partition { |u| white_list white_listed, u }
      end

      if verbose
        print "Links found: #{links.count}"
        print ", #{rejected.count} white listed" if white_listing
        print ", #{links.uniq.count} unique" if links.count != links.uniq.count
        puts ''
        links.uniq.each_with_index { |u, j| puts "  #{j + 1}. #{u}" }
      end

      print 'Checking URLs: ' if verbose && (links.count > 0)
      statuses =
        statuses(links.uniq, NUMBER_OF_THREADS) do |s|
          print(s == 200 ? STATUS_OK : STATUS_OTHER) if verbose
        end
      puts '' if verbose

      statuses_issues = statuses.select { |x| x['status'] != 200 }
      links_success = statuses_issues.count == 0

      unless skip_dupe
        dupe_success = links.uniq.count == links.count
        dupes = links.select { |e| links.count(e) > 1 }
      end

      if white_listing
        if verbose && (rejected.count > 0)
          print 'Checking white listed URLs: '
          wl = statuses(rejected.uniq, NUMBER_OF_THREADS, true) do |s|
            print(s == 200 ? STATUS_OK : STATUS_OTHER)
          end
          puts ''
        end
      end

      {
        'success' => links_success && dupe_success,
        'issues' => {
          'status' => statuses_issues,
          'dupe' => dupes
        },
        'results' => {
          'links' => links_success,
          'dupe' => dupe_success
        },
        'status' => statuses,
        'white_listed' => wl
      }
    end # run
  end # class
end
