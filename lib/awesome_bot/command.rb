require 'awesome_bot/links'
require 'awesome_bot/statuses'
require 'awesome_bot/version'
require 'awesome_bot/white_list'

# Command
module AwesomeBot
  NUMBER_OF_THREADS = 10

  OPTION_DUPE = 'allow-dupe'
  OPTION_WHITE_LIST = 'white-list'

  STATUS_OK = '✓'
  STATUS_OTHER = 'x'

  USAGE = "\t"

  class << self
    def cli
      option_d = "--#{OPTION_DUPE}"
      option_w = "--#{OPTION_WHITE_LIST}"

      if ARGV.count == 0
        puts "#{PROJECT_DESCRIPTION} \n"\
             "Usage: #{PROJECT} <file> [#{option_d}] "\
             "[#{option_w} item1,item2,..]\n"\
             "#{USAGE} file \t\t Path to file \n"\
             "#{USAGE} #{option_d} \t Skip checking for duplicate URLs \n"\
             "#{USAGE} #{option_w} \t Comma separated URLs to white list \n"\
             "\nSee #{PROJECT_URL} for more information"

        exit
      end

      filename = ARGV[0]
      puts "> Checking links in #{filename}"

      if ARGV.count > 1
        options = ARGV.drop 1

        skip_dupe = options.include? option_d

        if options.include? option_w
          i = options.find_index(option_w) + 1
          white_listed = options[i].split ','
        end
      end

      begin
        content = File.read filename
      rescue => error
        puts "File open error: #{error}"
        exit 1
      end

      exit 1 if run(content, white_listed, skip_dupe, true) == false

      exit
    end

    def run(content, white_listed = nil, skip_dupe = false, verbose = false)
      dupe_success = skip_dupe

      puts '> Will not check for duplicate links' if skip_dupe && verbose

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
        statuses links.uniq, NUMBER_OF_THREADS, verbose, STATUS_OK, STATUS_OTHER
      puts '' if verbose

      statuses_issues = statuses.select { |x| x['status'] != 200 }
      links_success = statuses_issues.count == 0

      unless skip_dupe
        dupe_success = links.uniq.count == links.count
        dupes = links.select { |e| links.count(e) > 1 }
      end

      if links_success && dupe_success
        puts 'No issues :-)' if verbose
        return true
      end

      if verbose
        puts "\nIssues :-("

        print "> Links \n"
        if links_success
          puts "  All OK #{STATUS_OK}"
        else
          statuses_issues.each_with_index do |x, k|
            puts "  #{k + 1}. #{x['status']} #{x['url']} "
          end
        end

        unless skip_dupe
          print "> Dupes \n"
          if dupe_success
            puts "  None #{STATUS_OK}"
          else
            dupes.uniq.each_with_index { |d, m| puts "  #{m + 1}. #{d}" }
          end
        end
      end # if verbose

      [false, statuses, dupes]
    end # run
  end # class
end
