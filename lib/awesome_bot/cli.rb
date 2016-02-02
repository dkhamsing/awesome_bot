require 'awesome_bot/check'
require 'awesome_bot/log'
require 'awesome_bot/result'
require 'awesome_bot/statuses'
require 'awesome_bot/version'

# Command line interface
module AwesomeBot
  OPTION_DUPE = 'allow-dupe'
  OPTION_REDIRECT = 'allow-redirect'
  OPTION_TIMEOUT_ALLOW = 'allow-timeout'
  OPTION_TIMEOUT_SET = 'set-timeout'
  OPTION_WHITE_LIST = 'white-list'
  OPTION_IGNORE_SSL = 'ignore-ssl'

  USAGE = "\t"

  class << self
    def make_option(o)
      "--#{o}"
    end

    def output(x, k)
      s = x['status']
      print "  #{k + 1}. "
      print "#{s} " unless s == STATUS_ERROR
      print "#{x['url']}"
      print " #{x['error']}" if s == STATUS_ERROR
      print " #{STATUS_REDIRECT} #{x['headers']['location']}" if status_is_redirected? s
      puts ''
    end

    def cli
      option_d = make_option OPTION_DUPE
      option_r = make_option OPTION_REDIRECT
      option_t = make_option OPTION_TIMEOUT_SET
      option_t_a = make_option OPTION_TIMEOUT_ALLOW
      option_w = make_option OPTION_WHITE_LIST
      option_i_s = make_option OPTION_IGNORE_SSL

      options = [
        option_d,
        option_r,
        option_t,
        option_t_a,
        option_w,
        option_i_s
      ]

      if ARGV.count == 0
        puts "Usage: #{PROJECT} <file> [#{option_d}] [#{option_r}] "\
             "[#{option_t_a}] [#{option_t} d] [#{option_i_s}] "\
             "[#{option_w} item1,item2,..]\n"\
             "#{USAGE} file             Path to file, required as first argument\n"\
             "#{USAGE} #{option_d}     Duplicates URLs are allowed URLs \n"\
             "#{USAGE} #{option_r} Redirected URLs are allowed \n"\
             "#{USAGE} #{option_t_a}  URLs that time out are allowed \n"\
             "#{USAGE} #{option_t}    Set connection timeout (seconds) \n"\
             "#{USAGE} #{option_w}     Comma separated URLs to white list \n"\
             "#{USAGE} #{option_i_s}     Do not verify SSL certificate \n"\
             "\nVersion #{VERSION}, see #{PROJECT_URL} for more information"
        exit
      end

      filename = ARGV[0]

      if options.include? filename
        puts "Usage: #{PROJECT} <file> [options] \n"\
             '                   Path to file, requried as first argument'
        exit 1
      end

      begin
        content = File.read filename
      rescue => error
        puts "File open error: #{error}"
        exit 1
      end

      puts "> Checking links in #{filename}"

      if ARGV.count > 1
        options = ARGV.drop 1

        skip_dupe = options.include? option_d

        allow_redirects = options.include? option_r
        puts '> Will allow redirects' if allow_redirects == true

        allow_timeouts = options.include? option_t_a
        puts '> Will allow network timeouts' if allow_timeouts == true

        if options.include? option_w
          i = options.find_index(option_w) + 1
          white_listed = options[i].split ','
        end

        if options.include? option_t
          i = options.find_index(option_t) + 1
          timeout = options[i].to_i
          puts "> Connection timeout = #{timeout}s"
        end

        ignore_ssl = options.include? option_i_s
        puts '> Will ignore SSL certificate validation' if ignore_ssl == true

      else
        allow_redirects = false
        allow_timeouts = false
        ignore_ssl = false
      end

      Faraday.options.timeout = timeout unless timeout.nil?
      Faraday.ssl.verify = !ignore_ssl

      log = Log.new(true)
      r = check(content, white_listed, skip_dupe, log)

      unless r.white_listed.nil?
        puts "\n> White list links matching:"
        r.white_listed.each_with_index do |x, k|
          output x, k
        end
      end

      if r.success(allow_redirects, allow_timeouts) == true
        puts 'No issues :-)'
        # exit ?
      else
        puts "\nIssues :-("

        print "> Links \n"
        if r.success_links(allow_redirects, allow_timeouts)
          puts "  All OK #{STATUS_OK}"
        else
          r.statuses_issues(allow_redirects, allow_timeouts)
            .each_with_index do |x, k|
              output x, k
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
