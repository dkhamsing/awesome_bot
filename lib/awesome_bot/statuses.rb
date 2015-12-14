# Get link status
module AwesomeBot
  require 'faraday'
  require 'parallel'

  STATUS_ERROR = -1

  class << self
    def net_head_status(url)
      Faraday.head(url).status
    end

    def net_get_status(url)
      Faraday.get(url).status
    end

    def net_status(url, head)
      head ? net_head_status(url) : net_get_status(url)
    end

    def statuses(links, threads, head = false)
      statuses = []
      Parallel.each(links, in_threads: threads) do |u|
        begin
          status = net_status u, head
        rescue => e
          status = STATUS_ERROR
          error = e
        end

        yield status, u
        statuses.push('url' => u, 'status' => status, 'error' => error)
      end # Parallel

      statuses
    end
  end # class
end
