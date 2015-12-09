# Process white list
module AwesomeBot
  class << self
    def white_list(list, item)
      list.each { |x| return true if item.include? x }
      false
    end
  end # class
end
