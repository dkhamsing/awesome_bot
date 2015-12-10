require 'awesome_bot/version'

# Command line interface
module AwesomeBot
  OPTION_DUPE = 'allow-dupe'
  OPTION_WHITE_LIST = 'white-list'

  USAGE = "\t"

  class << self
    def cli
      option_d = "--#{OPTION_DUPE}"
      option_w = "--#{OPTION_WHITE_LIST}"

      if ARGV.count == 0
        puts "Usage: #{PROJECT} <file> [#{option_d}] "\
             "[#{option_w} item1,item2,..]\n"\
             "#{USAGE} file \t\t Path to file \n"\
             "#{USAGE} #{option_d} \t Skip checking for duplicate URLs \n"\
             "#{USAGE} #{option_w} \t Comma separated URLs to white list \n"\
             "\nVersion #{VERSION}, see #{PROJECT_URL} for more information"
        exit
      end

      filename = ARGV[0]
      puts "> Checking links in #{filename}"

      if ARGV.count > 1
        options = ARGV.drop 1

        skip_dupe = options.include? option_d

        if options.include? option_w
          i = options.find_index(option_w) + 1
          white_listed = options[i].split ','
        end
      end

      begin
        content = File.read filename
      rescue => error
        puts "File open error: #{error}"
        exit 1
      end

      exit 1 unless check(content, white_listed, skip_dupe, true) == true

      exit
    end
  end # class
end
