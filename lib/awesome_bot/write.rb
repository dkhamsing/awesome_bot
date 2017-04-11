require 'json'

# Command line interface
module AwesomeBot
  RESULTS_PREFIX = 'ab-results'

  class << self
    def filter_filename(f)
      f.gsub('/','-')
    end

    def write_markdown_results(filename, filtered, silent)
      return false if silent==true

      payload =
      if filtered.nil?
        {'error'=>false}
      else
        results = File.read filtered
        j = JSON.parse results

        num = j.count
        plural = num==1?'':'s'
        title = "Found #{num} link issue#{plural}"
        message = "#### Link issue#{plural} by [`awesome_bot`](https://github.com/dkhamsing/awesome_bot)\n\n"
        message << "  Line | Status | Link\n"
        message << "| ---: | :----: | --- |\n"

        j.sort_by { |h| h['loc'] }.each do |i|
          error = i['error']
          loc   = i['loc']
          link  = i['link']
          s     = i['status']
          r     = i['redirect']

          if error=='Dupe'
            message << "#{loc} | Dupe | #{link} "
          else
            status = s==-1? 'Error' : "[#{s}](https://httpstatuses.com/#{s})"
            message << "#{loc} | #{status} | #{link} "
            message << "<br> #{error}" unless error ==''
            message << "redirects to<br>#{r}" unless r==''
          end
          message << "\n"
        end

        {
          'error'  => true,
          'title'  => title,
          'message'=> message
        }
      end

      results_file_filter = filter_filename filename
      results_file = "#{RESULTS_PREFIX}-#{results_file_filter}-markdown-table.json"
      File.open(results_file, 'w') { |f| f.write JSON.pretty_generate(payload) }
      puts "Wrote markdown table results to #{results_file}"

      return true
    end

    def write_results(f, r, silent)
      return false if silent==true

      results_file_filter = filter_filename f
      results_file = "#{RESULTS_PREFIX}-#{results_file_filter}.json"
      r.write results_file
      puts "\nWrote results to #{results_file}"

      return true
    end

    def write_results_filtered(file, filtered, silent)
      return nil if silent==true

      results_file_filter = filter_filename file
      results_file = "#{RESULTS_PREFIX}-#{results_file_filter}-filtered.json"
      File.open(results_file, 'w') { |f| f.write JSON.pretty_generate(filtered) }
      puts "Wrote filtered results to #{results_file}"

      return results_file
    end
  end # class
end
