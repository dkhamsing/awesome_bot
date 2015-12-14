require 'awesome_bot/white_list'

# Result
module AwesomeBot
  # Result
  class Result
    attr_accessor :dupes
    attr_accessor :skip_dupe
    attr_accessor :status
    attr_accessor :white_listed

    attr_reader :rejected
    attr_reader :links

    def initialize(links, white_list_from_cli)
      @links = links
      @w = white_list_from_cli

      return if @w.nil?
      @rejected, @links = links.partition { |u| AwesomeBot.white_list @w, u }
    end

    def statuses_issues(allow_redirects = false)
      s = status.select { |x| x['status'] != 200 }
      return s if allow_redirects == false

      s.reject { |x| (x['status'] > 299) && (x['status'] < 400) }
    end

    def success(allow_redirects = false)
      success_dupe && success_links(allow_redirects)
    end

    def success_dupe
      return true if skip_dupe
      links.uniq.count == links.count
    end

    def success_links(allow_redirects = false)
      statuses_issues(allow_redirects).count == 0
    end

    def white_listing
      !@w.nil?
    end
  end # class
end
