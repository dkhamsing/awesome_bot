# Get link status
module AwesomeBot
  require 'faraday'
  require 'parallel'

  class << self
    def net_status(url)
      Faraday.get(url).status
    end

    def statuses(links, threads)
      statuses = []
      Parallel.each(links, in_threads: threads) do |u|
        status = net_status u

        yield status, u

        statuses.push('url' => u, 'status' => status)
      end # Parallel

      statuses
    end
  end # class
end
