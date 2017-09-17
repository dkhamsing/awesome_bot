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
      repo = URI.parse(url)
      path = repo.path.split("/").select do |i| i != '' end
      return unless repo.hostname == 'github.com' and path.length == 2
      uri = "https://api.github.com/repos/#{path[0]}/#{path[1]}/commits"
      if token.nil? or token == ""
          json = HTTP.get(uri).to_s
      else
          json = HTTP.basic_auth(:user => user, :pass => token).get(uri).to_s
      end

      json = JSON.parse(json)
      if @json..kind_of?(Hash) and not json["message"].nil?
        puts json["message"]
        return -1;
      end
      (DateTime.now() - DateTime.parse(json[0]["commit"]["author"]["date"])).to_i
    end
  end
end
