# Get and filter links
module AwesomeBot
  require 'uri'

  class << self
    def links_filter(list)
      list.reject { |x| x.length < 9 }
        .map do |x|
          x.gsub(/\).*/, '').gsub(/'.*/, '').gsub(/,.*/, '').gsub('/:', '/')
        end
    end

    def links_find(content)
      URI.extract(content, /http()s?/)
    end
  end # class
end
