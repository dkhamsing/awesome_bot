require 'awesome_bot/check'
require 'awesome_bot/output'
require 'awesome_bot/result'
require 'awesome_bot/version'

# Command line interface
module AwesomeBot
  OPTION_DUPE = 'allow-dupe'
  OPTION_REDIRECT = 'allow-redirect'
  OPTION_TIMEOUT_ALLOW = 'allow-timeout'
  OPTION_TIMEOUT_SET = 'set-timeout'
  OPTION_WHITE_LIST = 'white-list'

  RESULTS_FILE = 'ab-results.json'

  USAGE = "\t"

  class << self
    def make_option(o)
      "--#{o}"
    end

    def divide(argv)
      params = { :files => [], :options => [] }
      argv.each_with_index do |a, i|
        if a !~ /^--.*/
          params[:files].push(a)
        else
          params[:options] = argv[i..argv.length]
          break
        end
      end
      return params
    end

    def cli
      option_d   = make_option OPTION_DUPE
      option_r   = make_option OPTION_REDIRECT
      option_t   = make_option OPTION_TIMEOUT_SET
      option_t_a = make_option OPTION_TIMEOUT_ALLOW
      option_w   = make_option OPTION_WHITE_LIST

      uoptions = [
        option_d,
        option_r,
        option_t,
        option_t_a,
        option_w
      ]

      if ARGV.count == 0
        puts "Usage: #{PROJECT} <file> [#{option_d}] [#{option_r}] "\
             "[#{option_t_a}] [#{option_t} d] "\
             "[#{option_w} item1,item2,..]\n"\
             "#{USAGE} file             Path to file, required as first argument\n"\
             "#{USAGE} #{option_d}     Duplicate URLs are allowed \n"\
             "#{USAGE} #{option_r} Redirected URLs are allowed \n"\
             "#{USAGE} #{option_t_a}  URLs that time out are allowed \n"\
             "#{USAGE} #{option_t}    Set connection timeout (seconds) \n"\
             "#{USAGE} #{option_w}     Comma separated URLs to white list \n"\
             "\nVersion #{VERSION}, see #{PROJECT_URL} for more information"
        exit
      end

      argv = divide ARGV

      if argv[:files].empty?
        puts "Usage: #{PROJECT} <file> [uoptions] \n"\
             '                   Path to file, requried as first argument'
        exit 1
      end

      argv[:files].each do |filename|

        # Check options
        user_options = ARGV.select { |o| o.include? '--' }
        options_diff = user_options - uoptions
        if options_diff.count > 0
          puts "Error, invalid options: #{options_diff.join ', '} \n"
          puts "Valid options are #{uoptions.join ', '}"
          exit 1
        end

        begin
          content = File.read filename
        rescue => error
          puts "File open error: #{error}"
          exit 1
        end

        puts "> Checking links in #{filename}"

        if argv[:options].count > 1
          options = argv[:options]

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
        else
          allow_redirects = false
          allow_timeouts = false
        end

        options = {
          'whitelist' => white_listed,
          'allowdupe' => skip_dupe,
          'timeout' => timeout
        }
        r = check content, options do |o|
          print o
        end

        digits = number_of_digits content
        unless r.white_listed.nil?
          puts "\n> White listed:"
          o = order_by_loc r.white_listed, content
          o.each_with_index do |x, k|
            puts output x, k, pad_list(o), digits
          end
        end

        if r.success(allow_redirects, allow_timeouts) == true
          puts "\nNo issues :-) \n\n"
          r.write RESULTS_FILE
        else
          puts "\nIssues :-( \n"

          print "> Links \n"
          if r.success_links(allow_redirects, allow_timeouts)
            puts "  All OK #{STATUS_OK}"
          else
            o = order_by_loc r.statuses_issues(allow_redirects, allow_timeouts), content
            o.each_with_index do |x, k|
              puts output x, k, pad_list(o), digits
            end
          end

          unless skip_dupe
            print "> Dupes \n"
            if r.success_dupe
              puts "  None #{STATUS_OK}"
            else
              dupe_hash = r.dupes.uniq.map do |x|
                temp = {}
                temp['url'] = x
                temp
              end
              o = order_by_loc dupe_hash, content
              largest = o.last['loc'].to_s.size
              o.each_with_index do |d, index|
                print "  #{pad_text index + 1, pad_list(r.dupes.uniq)}. "
                url = d['url']
                print loc_formatted d['loc'], largest
                puts " #{url}"
              end
            end
          end

          # write results json
          r.write RESULTS_FILE
          puts "\nWrote results to #{RESULTS_FILE}"

          exit 1
        end
      end
    end
  end # class
end
