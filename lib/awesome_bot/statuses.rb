# Get link status
module AwesomeBot
  STATUS_ERROR = -1

  class << self
    def net_status(url, timeout=30)
      require 'net/http'
      require 'openssl'
      require 'uri'

      uri = URI.parse url
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :open_timeout => timeout) do |http|
       request = Net::HTTP::Get.new uri
       response = http.request request

       code = response.code==nil ? 200 : response.code.to_i

       headers = {}
       response.each { |k, v| headers[k] = v }

       return [code, headers]
     end
    end

    def status_is_redirected?(status)
      (status > 299) && (status < 400)
    end

    def statuses(links, threads, timeout)
      require 'parallel'

      statuses = []
      Parallel.each(links, in_threads: threads) do |u|
        begin
          status, headers = net_status u, timeout
          error = nil # nil (success)
        rescue => e
          status = STATUS_ERROR
          headers = {}
          error = e
        end

        yield status, u if block_given?
        statuses.push('url' => u, 'status' => status, 'error' => error, 'headers' => headers)
      end # Parallel

      statuses
    end
  end # class
end
