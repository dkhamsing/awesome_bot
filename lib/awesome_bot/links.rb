# Get and filter links
module AwesomeBot
  require 'uri'
  require 'cgi'
  require 'github/markup'

  class << self
    # thanks: http://stackoverflow.com/a/7167988
    def link_valid?(uri)
      !!URI.parse(uri)
    rescue URI::InvalidURIError
      false
    end

    def links_filter(list)
      list.reject { |url| !link_valid?(url) }
    end

    def links_find(content)
      content.scan(/[a-z]+="(https?:\/\/.+?)"/).map { |x| CGI.unescapeHTML(x[0]) }
    end
  end # class
end
