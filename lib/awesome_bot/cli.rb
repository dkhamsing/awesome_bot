require 'awesome_bot/check'
require 'awesome_bot/output'
require 'awesome_bot/result'
require 'awesome_bot/version'

# Command line interface
module AwesomeBot
  RESULTS_FILE = 'ab-results.json'

  class << self
    def cli
      require 'optparse'

      ARGV << '-h' if ARGV.empty?

      options = {}
      ARGV.options do |opts|
        opts.banner = "Usage: #{PROJECT} [file] \n"\
                      "       #{PROJECT} [options]"

        opts.on("--files", Array, 'Files to check')  { |val| options['files'] = val }
        opts.on("--allow-dupe", TrueClass, 'Duplicate URLs are allowed')  { |val| options['allow_dupe'] = val }
        opts.on("--allow-redirect", TrueClass, 'Redirected URLs are allowed')  { |val| options['allow_redirect'] = val }
        opts.on("--allow-timeout", TrueClass, 'URLs that time out are allowed')  { |val| options['allow_timeout'] = val }
        opts.on("--set-timeout [seconds]", Integer, 'Set connection timeout')  { |val| options['timeout'] = val }
        opts.on("--white-list [urls]", String, 'Comma separated URLs to white list')  { |val| options['white_list'] = val }

        opts.on_tail("--help") do
          puts opts
          exit
        end
        opts.parse!
      end

      # warn ARGV
      # warn options

      files = options['files']
      files = ARGV[0] if files.nil?
      filename = files

      begin
        content = File.read filename
      rescue => error
        puts "File open error: #{error}"
        exit 1
      end

      puts "> Checking links in #{filename}"

      skip_dupe = options['allow_dupe']

      allow_redirects = options['allow_redirect']
      puts '> Will allow redirects' if allow_redirects == true

      allow_timeouts = options['allow_timeout']
      puts '> Will allow network timeouts' if allow_timeouts == true

      wl = options['white_list']
      white_listed = wl.split ',' unless wl.nil?

      timeout = options['timeout']
      puts "> Connection timeout = #{timeout}s" unless timeout.nil?

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
        puts 'No issues :-)'
        r.write RESULTS_FILE
      else
        puts "\nIssues :-("

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
  end # class
end
