# Output helpers
module AwesomeBot
  STATUS_OK = '✓'
  STATUS_OTHER = '?'
  STATUS_400s = 'x'
  STATUS_REDIRECT = '→'

  OUTPUT_SUMMARY_BASE = 'Will check relative links with base URL'
  OUTPUT_SUMMARY_CONNECTION = 'Connection timeout'
  OUTPUT_SUMMARY_DELAY = 'Will delay each request by'
  OUTPUT_SUMMARY_DUPE = 'Will allow duplicate links'
  OUTPUT_SUMMARY_ERRORS = 'Will allow errors'
  OUTPUT_SUMMARY_MARKDOWN = 'Will validate Markdown'
  OUTPUT_SUMMARY_REDIRECT = 'Will allow redirects'
  OUTPUT_SUMMARY_SAVE = 'Will not save results'
  OUTPUT_SUMMARY_SSL = 'Will allow SSL errors'
  OUTPUT_SUMMARY_TIMEOUT = 'Will allow network timeouts'
  OUTPUT_SUMMARY_WHITELIST = 'White list links matching'

  class << self
    def loc(x, content)
      count = 0
      lines = content.split "\n"
      lines.each do |l|
        count += 1
        return count if l.include? x
      end
      return count
    end

    def loc_formatted(loc, largest=3)
      line = pad_text loc, largest
      "[L#{line}]"
    end

    def log_status(s)
      if status_is_redirected? s
        return STATUS_REDIRECT
      elsif s == 200
        return STATUS_OK
      elsif (s > 399 && s < 500)
        return STATUS_400s
      else
        return STATUS_OTHER
      end
    end

    def number_of_digits(content)
      lines = content.split "\n"
      return pad_list lines
    end

    def order_by_loc(list, content)
      list.each do |x|
        x['loc'] = loc x['url'], content
      end

      s = list.sort_by { |h| h['loc'] }
      return s
    end

    def output(x, index, total, largest)
      s = x['status']

      loc = x['loc']
      status = s == STATUS_ERROR ? '' : s
      link = x['url']
      redirect = status_is_redirected?(s) ? x['headers']['location'] : ''
      error = s == STATUS_ERROR ? x['error'] : ''

      hash = {
        'loc'=> loc,
        'status'=> s,
        'link'=> link,
        'redirect'=> redirect,
        'error'=> error
      }

      o =
      "  #{pad_text index + 1, total}. " \
      "#{loc_formatted loc, largest} " \
      "#{status} " \
      "#{link} " \
      "#{error}" \
      "#{output_redirect x} \n"

      [o, hash]
    end

    def output_filtered(content, r, options)
      filtered_issues = []

      markdown = options['markdown']
      unless markdown.nil?
        print "> Markdown Validation \n"
        if r.success_validate
          puts "  OK #{STATUS_OK}"
        else
          r.validate.each_with_index do |x, i|
            locv = loc(x, content)
            error = RESULT_ERROR_MARKDOWN

            hash = {
              'loc'=> locv,
              'link'=> x,
              'error'=> error
            }
            filtered_issues.push hash

            print "  #{i+1} "
            print loc_formatted locv
            puts " #{x} \n"
          end
        end
      end

      print "> Links \n"
      if r.success_links(options)
        puts "  OK #{STATUS_OK}"
      else
        o = order_by_loc r.statuses_issues(options), content
        digits = number_of_digits content
        o.each_with_index do |x, k|
          temp, h = output(x, k, pad_list(o), digits)
          filtered_issues.push h
          puts temp
        end
      end

      skip_dupe = options['skip_dupe']
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
            loc = d['loc']
            url = d['url']
            error = RESULT_ERROR_DUPE

            hash = {
              'loc'=> loc,
              'link'=> url,
              'error'=> error
            }
            filtered_issues.push hash

            print "  #{pad_text index + 1, pad_list(r.dupes.uniq)}. "
            print loc_formatted loc, largest
            puts " #{url}"
          end
        end
      end

      filtered_issues
    end

    def output_redirect(x)
      if status_is_redirected? x['status']
        " #{STATUS_REDIRECT} #{x['headers']['location']}"
      else
        ''
      end
    end

    def output_summary(options)
      o = ''
      markdown = options['markdown']
      o << "> #{OUTPUT_SUMMARY_MARKDOWN} \n" unless markdown.nil?

      base = options['base_url']
      o << "> #{OUTPUT_SUMMARY_BASE} #{base} \n" unless base.nil?

      errors = options['errors']
      o << "> #{OUTPUT_SUMMARY_ERRORS}: #{errors.join ','}" unless errors.nil?

      skip_dupe = options['allow_dupe']
      o << "> #{OUTPUT_SUMMARY_DUPE}" unless skip_dupe.nil?

      allow_redirects = options['allow_redirect']
      o << "> #{OUTPUT_SUMMARY_REDIRECT}" unless allow_redirects.nil?

      allow_ssl = options['allow_ssl']
      o << "> #{OUTPUT_SUMMARY_SSL}" unless allow_ssl.nil?

      allow_timeouts = options['allow_timeout']
      o << "> #{OUTPUT_SUMMARY_TIMEOUT}" unless allow_timeouts.nil?

      delay = options['delay']
      o << "> #{OUTPUT_SUMMARY_DELAY} #{delay} second#{delay==1? '': 's'}" unless delay.nil?

      timeout = options['timeout']
      o << "> #{OUTPUT_SUMMARY_CONNECTION} = #{timeout}s" unless timeout.nil?

      white_listed = options['white_list']
      o << "> #{OUTPUT_SUMMARY_WHITELIST}: #{white_listed.join ', '} " unless white_listed.nil?

      no_results = options['no_results']
      o << "> #{OUTPUT_SUMMARY_SAVE}" unless no_results.nil?

      o
    end

    def pad_list(list)
      list.count.to_s.size
    end

    def pad_text(number, digits)
      format = "%0#{digits}d"
      "#{sprintf format, number}"
    end
  end # class
end
