# Get link status
module AwesomeBot
  require 'faraday'
  require 'parallel'

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
          status = e
        end

        yield status, u
        statuses.push('url' => u, 'status' => status)
      end # Parallel

      statuses
    end
  end # class
end
