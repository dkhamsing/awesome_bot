# Result
module AwesomeBot
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

    def statuses_issues(options=nil)
      options = {
        'timeout'=>false,
        'ssl'=>false,
        'redirect'=>false
      } if options.nil?

      s = status.select { |x| x['status'] != 200 }

      if options['timeout']
        s = s.reject do |x|
          ( (x['error'].message == 'Net::ReadTimeout') || (x['error'].message == 'execution expired') || (x['error'].message.include? 'timed out') ) unless x['error'].nil?
        end
      end

      if options['redirect']
        s = s.reject { |x| AwesomeBot.status_is_redirected? x['status'] }
      end

      if options['ssl']
        s =  s.reject do |x|
          ( (x['error'].message.include? 'server certificate') || (x['error'].message.include? 'SSL_connect') ) unless x['error'].nil?
        end
      end

      s
    end

    def success(options)
      success_dupe && success_links(options)
    end

    def success_dupe
      return true if skip_dupe
      links.uniq.count == links.count
    end

    def success_links(options)
      statuses_issues(options).count==0
    end

    def white_listing
      !@w.nil?
    end

    def write(filename)
      require 'json'

      r = write_artifacts
      File.open(filename, 'w') { |f| f.write r.to_json }
    end

    def write_artifacts
      require 'date'
      {
        'date'=>Time.now,
        'links'=>@links,
        'results'=>statuses_issues
      }
    end
  end # class
end
