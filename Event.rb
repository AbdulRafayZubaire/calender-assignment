class Event
  attr_accessor :title, :date

  def initialize(title, date)
    @title = title
    @date = date
  end

  def show_event
    print "#{@title}".ljust(50), "#{@date.strftime('%B %d, %Y')} \n"
  end
end
