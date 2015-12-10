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

    def statuses(links, threads, head = false)
      statuses = []
      Parallel.each(links, in_threads: threads) do |u|
        status =
          if head
            net_head_status u
          else
            net_get_status u
          end

        yield status, u

        statuses.push('url' => u, 'status' => status)
      end # Parallel

      statuses
    end
  end # class
end
