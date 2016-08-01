# Output helpers
module AwesomeBot
  STATUS_OK = '✓'
  STATUS_OTHER = '?'
  STATUS_400s = 'x'
  STATUS_REDIRECT = '→'

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

    def output_redirect(x)
      if status_is_redirected? x['status']
        " #{STATUS_REDIRECT} #{x['headers']['location']}"
      else
        ''
      end
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
