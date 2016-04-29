# Get link status
module AwesomeBot
  require 'net/http'
  require 'openssl'
  require 'uri'

  require 'parallel'

  STATUS_ERROR = -1

  class << self
    def net_status(url, head, timeout=30)
      uri = URI.parse url
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :open_timeout => timeout) do |http|
       request = Net::HTTP::Get.new uri
       response = http.request request
       return response
     end
    end

    def status_is_redirected?(status)
      (status > 299) && (status < 400)
    end

    def statuses(links, threads, timeout, head=false)
      statuses = []
      Parallel.each(links, in_threads: threads) do |u|
        begin
          response = net_status u, head, timeout
          status = response.code.to_i
          status = 200 if status.nil?
          headers = {}
          response.each { |k, v| headers[k] = v }
          error = nil # nil (success)
        rescue => e
          status = STATUS_ERROR
          headers = {}
          error = e
        end

        yield status, u
        statuses.push('url' => u, 'status' => status, 'error' => error, 'headers' => headers)
      end # Parallel

      statuses
    end
  end # class
end
