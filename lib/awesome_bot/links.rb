# Get and filter links
module AwesomeBot
  class << self
    def links_filter(list)
      list.reject { |x| x.length < 9 }
        .map do |x|
          x.gsub(',','%2c').gsub(/'.*/, '').gsub(/,.*/, '').gsub('/:', '/')
        end
        .map do |x|
          if x.include? ')]'
            x.gsub /\)\].*/, ''
          elsif (x.scan(')').count == 2) && (x.scan('(').count == 1)
            x.gsub(/\)\).*/, ')')
          elsif x.scan(')').count > 0
            x.gsub(/\).*/, '')
          elsif x.include? '[' # adoc
            x.gsub(/\[.*/, '')
          else
            x
          end
        end
    end

    def links_find(content)
      require 'uri'
      URI.extract(content, /http()s?/)
    end
  end # class
end
