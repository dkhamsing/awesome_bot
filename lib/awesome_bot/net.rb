# Get link status
module AwesomeBot
  STATUS_ERROR = -1

  class << self
    def net_status(url, timeout=30, head)
      require 'net/http'
      require 'openssl'
      require 'uri'

      uri = URI.parse url
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :open_timeout => timeout) do |http|
        ua = {'User-Agent' => 'awesome_bot'}
        if head
          request = Net::HTTP::Head.new(uri,ua)
        else
          request = Net::HTTP::Get.new(uri,ua)
        end

        if uri.userinfo
          auth_user, auth_pass = uri.userinfo.split(/:/)
          request.basic_auth auth_user, auth_pass
        end

        response = http.request request

        code = response.code==nil ? 200 : response.code.to_i

        headers = {}
        response.each do |k, v|
          headers[k] = v.force_encoding("utf-8")
        end

        # handle incomplete redirect
        loc = headers['location']
        unless loc.nil?
          loc_uri = URI.parse loc
          if loc_uri.scheme.nil?
            new_loc = uri.scheme + '://' + uri.host + loc
            headers['location'] = new_loc
          end
        end

        return [code, headers]
      end
    end

    def status_is_redirected?(status)
      (status > 299) && (status < 400)
    end

    def statuses(links, threads, timeout, head=false, delay=0)
      require 'parallel'

      statuses = []
      Parallel.each(links, in_threads: threads) do |u|
        sleep delay
        begin
          status, headers = net_status u, timeout, head
          error = nil
        rescue => e
          status = STATUS_ERROR
          headers = {}
          error = e
        end

        yield status, u, headers if block_given?
        statuses.push('url' => u, 'status' => status, 'error' => error, 'headers' => headers)
      end # Parallel

      statuses
    end
  end # class
end
