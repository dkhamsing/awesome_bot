# Result
module AwesomeBot
  require 'awesome_bot/statuses'
  require 'awesome_bot/white_list'

  # Result
  class Result
    attr_accessor :dupes
    attr_accessor :skip_dupe
    attr_accessor :status
    attr_accessor :white_listed

    attr_reader :links_white_listed
    attr_reader :links

    def initialize(links, white_list_from_cli)
      @links = links
      @w = white_list_from_cli

      return if @w.nil?
      @links_white_listed,
      @links = links.partition { |u| AwesomeBot.white_list @w, u }
    end

    def statuses_issues(allow_redirects = false, allow_timeouts = false)
      s = status.select { |x| x['status'] != 200 }
      r = s.reject { |x| AwesomeBot.status_is_redirected x['status'] }
      t = s.reject do |x|
        (x['status'] == -1) && ((x['error'].message == 'Net::ReadTimeout') || (x['error'].message == 'execution expired'))
      end

      if (allow_redirects == false) && (allow_timeouts == false)
        return s
      elsif (allow_redirects == true) && (allow_timeouts == false)
        return r
      elsif (allow_redirects == false) && (allow_timeouts == true)
        return t
      else
        return r.reject do |x|
          (x['status'] == -1) && ((x['error'].message == 'Net::ReadTimeout') || (x['error'].message == 'execution expired'))
        end
      end
    end

    def success(allow_redirects = false, allow_timeouts = false)
      success_dupe && success_links(allow_redirects, allow_timeouts)
    end

    def success_dupe
      return true if skip_dupe
      links.uniq.count == links.count
    end

    def success_links(allow_redirects = false, allow_timeouts = false)
      statuses_issues(allow_redirects, allow_timeouts).count == 0
    end

    def white_listing
      !@w.nil?
    end
  end # class
end
