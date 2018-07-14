# Get and filter links
module AwesomeBot
  # This matches, from left to right:
  # a literal [
  # the link title - i.e. anything up to the next closing bracket
  # a literal ]
  # a literal (
  # the link destination (optionally enclosed in a single pair of angle brackets)
  # a literal )
  MARKDOWN_LINK_REGEX = /\[ [^\]]+ \] \( <? ([^)<>]+) >? \)/x

  class << self
    def links_filter(list)
      list.reject { |x| x.length < 9 }
        .map do |x|
          x.gsub(',','%2c').gsub(/'.*/, '').gsub(/,.*/, '')
        end
        .map do |x|
          if x.include? ')]'
            x.gsub /\)\].*/, ''
          elsif (x.scan(')').count == 2) && (x.scan('(').count == 1)
            x.gsub(/\)\).*/, ')')
          elsif (x.scan(')').count > 0)
            if (x.include? 'wikipedia')
              if (x.scan(')').count >= 1) && (x.scan('(').count == 0)
                x.gsub(/\).*/, '')
              else
                x
              end
            else
              x.gsub(/\).*/, '')
            end
          elsif x.include? '[' # adoc
            x.gsub(/\[.*/, '')
          elsif x[-1]=='.' || x[-1]==':'
            x[0..-2]
          elsif x[-1]=='.'
            x[0..-2]
          elsif x[-3..-1]=='%2c'
            x[0..-4]
          else
            x
          end
        end
    end

    def links_find(content, url_base=nil)
      require 'uri'
      ext = URI.extract(content, /http()s?/)
      return ext if url_base.nil?

      rel = get_relative_links content, url_base
      return rel + ext
    end

    def get_relative_links(content, base)
      links = []
      content.scan(MARKDOWN_LINK_REGEX) { |groups| links << groups.first }

      links.reject { |x| x.include?('http') || x.include?('#') }
        .map { |x| x =~ /\S/ ? x.match(/^\S*/) : x }
        .map { |x| "#{base}#{x}"}
    end
  end # class
end
