# Get link status
module AwesomeBot
  require 'faraday'
  require 'parallel'

  STATUS_ERROR = -1

  class << self
    def net_head_status(url)
      Faraday.head(url)
    end

    def net_get_status(url)
      Faraday.get(url)
    end

    def net_status(url, head)
      head ? net_head_status(url) : net_get_status(url)
    end

    def statuses(links, threads, head = false)
      statuses = []
      Parallel.each(links, in_threads: threads) do |u|
        begin
          response = net_status u, head
          status = response.status
          headers = response.headers
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
