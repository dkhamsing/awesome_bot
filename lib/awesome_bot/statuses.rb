# Get link status
module AwesomeBot
  require 'faraday'
  require 'parallel'

  class << self
    def net_status(url)
      Faraday.get(url).status
    end

    def statuses(links, threads, verbose, status_ok, status_other)
      statuses = []
      Parallel.each(links, in_threads: threads) do |u|
        status = net_status u

        print(status == 200 ? status_ok : status_other) if verbose

        statuses.push('url' => u, 'status' => status)
      end # Parallel

      statuses
    end
  end # class
end
