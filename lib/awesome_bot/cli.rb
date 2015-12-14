require 'awesome_bot/check'
require 'awesome_bot/log'
require 'awesome_bot/result'
require 'awesome_bot/version'

# Command line interface
module AwesomeBot
  OPTION_DUPE = 'allow-dupe'
  OPTION_REDIRECT = 'allow-redirect'
  OPTION_WHITE_LIST = 'white-list'

  USAGE = "\t"

  class << self
    def cli
      option_d = "--#{OPTION_DUPE}"
      option_r = "--#{OPTION_REDIRECT}"
      option_w = "--#{OPTION_WHITE_LIST}"

      if ARGV.count == 0
        puts "Usage: #{PROJECT} <file> [#{option_d}] [#{option_r}] "\
             "[#{option_w} item1,item2,..]\n"\
             "#{USAGE} file \t\t Path to file \n"\
             "#{USAGE} #{option_d} \t  Duplicates URLs are allowed URLs \n"\
             "#{USAGE} #{option_r} Redirected URLs are allowed \n"\
             "#{USAGE} #{option_w} \t  Comma separated URLs to white list \n"\
             "\nVersion #{VERSION}, see #{PROJECT_URL} for more information"
        exit
      end

      filename = ARGV[0]
      puts "> Checking links in #{filename}"

      if ARGV.count > 1
        options = ARGV.drop 1

        skip_dupe = options.include? option_d

        allow_redirects = options.include? option_r
        puts '> Will allow redirects' if allow_redirects == true

        if options.include? option_w
          i = options.find_index(option_w) + 1
          white_listed = options[i].split ','
        end
      else
        allow_redirects = false
      end

      begin
        content = File.read filename
      rescue => error
        puts "File open error: #{error}"
        exit 1
      end


      log = Log.new(true)
      r = check(content, white_listed, skip_dupe, log)

      unless r.white_listed.nil?
        puts "\n> White listed:"
        r.white_listed.each_with_index do |x, k|
          puts "  #{k + 1}. #{x['status']}: #{x['url']} "
        end
      end

      if r.success(allow_redirects) == true
        puts 'No issues :-)'
        # exit ?
      else
        puts "\nIssues :-("

        print "> Links \n"
        if r.success_links(allow_redirects)
          puts "  All OK #{STATUS_OK}"
        else
          r.statuses_issues(allow_redirects).each_with_index do |x, k|
            s = x['status']
            print "#{k + 1}. "
            print "#{s} " unless s == STATUS_ERROR
            print "#{x['url']}"
            print x['error'] if s == STATUS_ERROR
            puts ''
          end
        end

        unless skip_dupe
          print "> Dupes \n"
          if r.success_dupe
            puts "  None #{STATUS_OK}"
          else
            r.dupes.uniq.each_with_index { |d, m| puts "  #{m + 1}. #{d}" }
          end
        end

        exit 1
      end
    end
  end # class
end
