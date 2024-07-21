require_relative 'event'
require_relative 'validation'
require_relative 'event_display'

class EventCollection
  include Validation
  include EventDisplay
  attr_accessor :events

  def initialize
    @events = Hash.new do |hash, key|
      hash[key] = Hash.new do |hash, key|
        hash[key] = Hash.new do |hash, key|
          hash[key] = []
        end
      end
    end
  end

  def add_event
    event = EventDisplay.add_event
    @events[event.date.year][event.date.month][event.date.day].push(event)
  end

  def view_event
    loop do
      event_date = EventDisplay.read_date

      title = Validation.string_input { 'Title: ' }

      filtered_events = @events.dig(event_date.year, event_date.month, event_date.day)

      event_to_view = filtered_events.find { |event| event.title == title }

      if event_to_view
        EventDisplay.show(event_to_view)
        return
      else
        puts "Event not found for #{event_date.strftime('%B %d, %Y')}. Please enter a valid date."

        print 'Try Again (Yes/No): '
        !Validation.validated_boolean_input && return

        next
      end
    end
  end

  def edit_event
    loop do
      event_date = EventDisplay.read_date
      filtered_events = @events.dig(event_date.year, event_date.month, event_date.day)

      if filtered_events.length == 0
        puts "Event not found for #{event_date.strftime('%B %d, %Y')}. Please enter a valid date."

        print 'Try Again (Yes/No): '
        return false unless Validation.validated_boolean_input

        next
      else

        print 'No.'.ljust(5), 'Title'.ljust(50), "Date\n"
        puts '-' * 70

        filtered_events.each_with_index do |event, index|
          print "#{index + 1}.".ljust(5), "#{event.title}".ljust(50), "#{event.date.strftime('%B %d, %Y')} \n"
          # print "#{index+1}".ljust(5), EventDisplay.show(event)
        end

        print 'Select an event number from Above to Edit: '
        selected_event = Validation.validated_numeric_input(1..filtered_events&.length)
      end

      # sending the event to take new inputs
      edited_event = EventDisplay.edit_event(filtered_events[selected_event - 1]) # array offset

      return true if edited_event == true

      # deleteing the event from current Location if date is changed
      @events[event_date.year][event_date.month][event_date.day].delete(filtered_events[selected_event - 1]) # array offset
      @events[edited_event.date.year][edited_event.date.month][edited_event.date.day].push(edited_event)
      return true
    end
  end

  def delete_event
    loop do
      event_date = EventDisplay.read_date
      filtered_events = @events.dig(event_date.year, event_date.month, event_date.day)

      if filtered_events.length.zero?
        puts "Event not found for #{event_date.strftime('%B %d, %Y')}. Please enter a valid date."

        print 'Try Again (Yes/No): '
        return false unless Validation.validated_boolean_input

        next
      else

        print 'No.'.ljust(5), 'Title'.ljust(50), "Date\n"
        puts '-' * 70

        filtered_events.each_with_index do |event, index|
          print "#{index + 1}".ljust(5), "#{event.title}".ljust(50), "#{event.date.strftime('%B %d, %Y')} \n"
        end

        print 'Select an event number from Above to Delete: '
        selected_event = Validation.validated_numeric_input(1..filtered_events&.length)
      end

      @events[event_date.year][event_date.month][event_date.day].delete(filtered_events[selected_event - 1]) # array
      return true
    end
  end

  def display_events_by_month
    month_events = []
    loop do
      year = Validation.validated_year_input
      month = Validation.validated_month_input

      month_events = @events.dig(year, month)

      if month_events.empty?
        puts 'There are currently no events in this month!'

        print 'Try Again (Yes/No): '
        !Validation.validated_boolean_input && return

        next
      end
      break
    end

    month_events.each do |_, day_events|
      next unless day_events.is_a?(Array) # incase array is empty, could have used safe nav as well

      puts `clear`

      print 'No.'.ljust(5), 'Title'.ljust(50), "Date\n"
      puts '-' * 70
      day_events.each_with_index do |event, index|
        # print "#{index+1}".ljust(5), EventDisplay.show(event)
        print "#{index + 1}".ljust(5), "#{event.title}".ljust(50), "#{event.date.strftime('%B %d, %Y')}\n"
      end
    end
  end

  def display_events_by_date
    loop do
      event_date = EventDisplay.read_date
      filtered_events = @events.dig(event_date.year, event_date.month, event_date.day)

      if filtered_events.length.zero?
        puts "Events not found for #{event_date.strftime('%B %d, %Y')}. Please enter a valid date."

        print 'Try Again (Yes/No): '
        !Validation.validated_boolean_input && return
        next
      else

        print 'No.'.ljust(5), 'Title'.ljust(50), "Date\n"
        puts '-' * 70

        filtered_events.each_with_index do |event, index|
          print "#{index + 1}.".ljust(5), "#{event.title}".ljust(50), "#{event.date.strftime('%B %d, %Y')} \n"
          # print "#{index+1}".ljust(5), EventDisplay.show(event)
        end
      end
      return
    end
  end

  def display_all_events
    puts `clear`

    if @events.size.zero?
      puts 'There are currently no events in your calender!'
      return
    end

    print 'Title'.ljust(50), "Date\n"
    puts '-' * 70
    @events.each do |_, year|
      year.each do |_, month|
        month.each do |_, day|
          day.each do |event|
            EventDisplay.show(event)
          end
        end
      end
    end
  end
end
