# Log
module AwesomeBot
  # Log
  class Log
    def initialize(verbose = false)
      @v = verbose
    end

    def add(message)
      puts message if @v
    end

    def addp(message)
      print message if @v
    end
  end # class
end
