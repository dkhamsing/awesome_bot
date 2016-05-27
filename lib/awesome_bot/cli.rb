require 'awesome_bot/check'
require 'awesome_bot/output'
require 'awesome_bot/result'
require 'awesome_bot/version'

# Command line interface
module AwesomeBot
  RESULTS_PREFIX = 'ab-results'

  class << self
    def cli()
      require 'optparse'

      ARGV << '-h' if ARGV.empty?

      options = {}
      ARGV.options do |opts|
        opts.banner = "Usage: #{PROJECT} [file or files] \n"\
                      "       #{PROJECT} [options]"

        opts.on('-f', '--files [files]',         Array,     'Comma separated files to check')     { |val| options['files'] = val }
        opts.on('--allow-dupe',                  TrueClass, 'Duplicate URLs are allowed')         { |val| options['allow_dupe'] = val }
        opts.on('--allow-ssl',                   TrueClass, 'SSL errors are allowed')             { |val| options['allow_ssl'] = val }
        opts.on('--allow-redirect',              TrueClass, 'Redirected URLs are allowed')        { |val| options['allow_redirect'] = val }
        opts.on('--allow-timeout',               TrueClass, 'URLs that time out are allowed')     { |val| options['allow_timeout'] = val }
        opts.on('-t', '--set-timeout [seconds]', Integer,   'Set connection timeout')             { |val| options['timeout'] = val }
        opts.on('-w', '--white-list [urls]',     Array,     'Comma separated URLs to white list') { |val| options['white_list'] = val }

        opts.on_tail("--help") do
          puts opts
          exit
        end
        opts.parse!
      end

      files = options['files']
      if files.nil?
        files = []
        ARGV.each do |a|
          files.push a if a !~ /^--.*/
        end
      end

      summary = {}
      files.each do |f|
        summary[f] = cli_process(f, options)
      end

      if summary.count>1
        puts "\nSummary"

        largest = 0
        summary.each do |k, v|
          s = k.size
          largest = s if s>largest
        end

        summary.each do |k, v|
          k_display = "%#{largest}.#{largest}s" % k
          puts "#{k_display}: #{v}"
        end
      end

      summary.each { |k, v| exit 1 unless v==STATUS_OK }
    end

    def cli_process(filename, options)
      begin
        content = File.read filename
      rescue => error
        puts "File open error: #{error}"
        return error
      end

      puts "> Checking links in #{filename}"

      skip_dupe = options['allow_dupe']
      puts '> Will allow duplicate links' if skip_dupe == true

      allow_redirects = options['allow_redirect']
      puts '> Will allow redirects' if allow_redirects == true

      allow_ssl = options['allow_ssl']
      puts '> Will allow SSL errors' if allow_ssl == true

      allow_timeouts = options['allow_timeout']
      puts '> Will allow network timeouts' if allow_timeouts == true

      white_listed = options['white_list']

      timeout = options['timeout']
      puts "> Connection timeout = #{timeout}s" unless timeout.nil?

      puts "> White list links matching: #{white_listed.join ', '} " unless white_listed.nil?

      options = {
        'allowdupe' => skip_dupe,
        'timeout'   => timeout,
        'whitelist' => white_listed
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

      allow_redirects = false if allow_redirects.nil?
      allow_ssl = false if allow_ssl.nil?
      allow_timeouts = false if allow_timeouts.nil?

      options = {
        'redirect' => allow_redirects,
        'ssl'      => allow_ssl,
        'timeout'  => allow_timeouts
      }

      if r.success(options) == true
        puts 'No issues :-)'
        cli_write_results(filename, r)
        return STATUS_OK
      else
        puts "\nIssues :-("

        print "> Links \n"
        if r.success_links(options)
          puts "  All OK #{STATUS_OK}"
        else
          o = order_by_loc r.statuses_issues(options), content
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

        cli_write_results(filename, r)
        return 'Issues'
      end
    end

    def cli_write_results(f, r)
      results_file_filter = f.gsub('/','-')
      results_file = "#{RESULTS_PREFIX}-#{results_file_filter}.json"
      r.write results_file
      puts "\nWrote results to #{results_file}"
    end
  end # class
end
