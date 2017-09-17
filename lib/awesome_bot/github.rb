module AwesomeBot
  class << self
    def github_age(url)
      require 'net/http'
      require 'openssl'
      require 'uri'
      require 'json'
      require 'date'
      require 'http'

      user = ENV["GH_USER"]
      token = ENV["GH_TOKEN"]
      if token.nil? or token == ""
        abort ("Must specify a GH_TOKEN env variable")
      end
      repo = URI.parse(url)
      path = repo.path.split("/").select do |i| i != '' end
      return unless repo.hostname == 'github.com' and path.length == 2
      json = HTTP.basic_auth(:user => user, :pass => token).get("https://api.github.com/repos/#{path[0]}/#{path[1]}/commits").to_s
      (DateTime.now() - DateTime.parse(JSON.parse(json)[0]["commit"]["author"]["date"])).to_i
    end
  end
end
