# Result
module AwesomeBot
  require 'awesome_bot/white_list'

  RESULT_ERROR_DUPE = 'Dupe'
  RESULT_ERROR_MARKDOWN = 'Markdown (missing space)'

  # Result
  class Result
    attr_accessor :dupes
    attr_accessor :allow_dupe
    attr_accessor :status
    attr_accessor :validate
    attr_accessor :white_listed

    attr_reader :links_white_listed
    attr_reader :links

    def initialize(links, white_list_from_cli)
      @links = links
      @w = white_list_from_cli

      return if @w.nil?
      @links_white_listed,
      @links = links.partition { |u| AwesomeBot.whitelisted @w, u }
    end

    def statuses_issues(options=nil)
      options = {
        'allow_timeout'=>false,
        'allow_ssl'=>false,
        'allow_redirect'=>false
      } if options.nil?

      s = status.select { |x| x['status'] != 200 }

      if options['allow_timeout']
        s = s.reject do |x|
          ( (x['error'].message == 'Net::ReadTimeout') || (x['error'].message == 'execution expired') || (x['error'].message.include? 'timed out') ) unless x['error'].nil?
        end
      end

      if options['allow_redirect']
        s = s.reject { |x| AwesomeBot.status_is_redirected? x['status'] }
      end

      if options['allow_ssl']
        s =  s.reject do |x|
          ( (x['error'].message.include? 'server certificate') || (x['error'].message.include? 'SSL_connect') ) unless x['error'].nil?
        end
      end

      unless options[CLI_OPT_ERRORS].nil?
        options[CLI_OPT_ERRORS].each do |c|
          s = s.reject { |x| x['status']==c.to_i }
        end
      end

      s
    end

    def success(options)
      success_links(options) && success_dupe && success_validate
    end

    def success_dupe
      return true if allow_dupe
      links.uniq.count == links.count
    end

    def success_links(options)
      statuses_issues(options).count==0
    end

    def success_validate
      return validate.count==0
    end

    def white_listing
      !@w.nil?
    end

    def write(filename)
      require 'json'

      r = write_artifacts
      File.open(filename, 'w') { |f| f.write JSON.pretty_generate(r) }
    end

    def write_artifacts
      require 'date'
      {
        'date'=>Time.now,
        'links'=>@links,
        'issues'=>statuses_issues,
        'all'=>status
      }
    end
  end # class
end
