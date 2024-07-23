require_relative 'event'
require_relative 'event_validation'
require_relative 'event_display'
require 'pry'
$TITLE_WIDTH = 70

class EventCollection
  include EventValidation
  include EventDisplay
  attr_accessor :events

  def initialize
    # @events = {year: {month: {day: [...events]}}}
    @events = Hash.new do |hash, key|
      hash[key] = Hash.new do |hash, key|
        hash[key] = Hash.new do |hash, key|
          hash[key] = []
        end
      end
    end
  end

  def add_event(user_input)
    event = Event.new(user_input[:title], Date.new(user_input[:year], user_input[:month], user_input[:date]))
    @events[event.date.year][event.date.month][event.date.day].push(event)
    event
  end

  def find_event(event_date, title)
    filtered_events = @events.dig(event_date.year, event_date.month, event_date.day)
    filtered_events.find { |event| event.title == title }
  end

  def view_event(title, event_date)
    event_to_view = find_event(event_date, title)

    if event_to_view
      EventDisplay.show(event_to_view)
      event_to_view
    else
      puts "Event not found for #{event_date.strftime('%B %d, %Y')}. Please enter a valid date."
    end
  end

  # takes date input of the event user wants to edit
  def edit_event_input(event_date)
    filtered_events = @events.dig(event_date.year, event_date.month, event_date.day)

    if filtered_events.length == 0

      return true if EventDisplay.try_again? do
                       puts "Event not found for #{event_date.strftime('%B %d, %Y')}. Please enter a valid date."
                     end

      return false
    else
      selected_event = EventDisplay.display_events_with_index_with_output(filtered_events)
    end
    [false, selected_event]
  end

  # perform updation on some chosen event
  def edit_event(selected_event, previous_date, attribute)
    filtered_events = @events[previous_date.year][previous_date.month][previous_date.day]
    event_to_edit = filtered_events[selected_event - 1]

    if attribute['attr_to_edit'] == 'title'
      event_to_edit.title = attribute['value']
      return event_to_edit
    end
    event_to_edit.date = attribute['value'] if attribute['attr_to_edit'] == 'date'
    # binding.pry

    # poping the event from current Location if date is changed
    @events[previous_date.year][previous_date.month][previous_date.day].delete(event_to_edit) # array offset
    @events[event_to_edit.date.year][event_to_edit.date.month][event_to_edit.date.day].push(event_to_edit)
    event_to_edit
  end

  def delete_event_input(event_date)
    filtered_events = @events.dig(event_date.year, event_date.month, event_date.day)

    if filtered_events.length.zero?
      return true if EventDisplay.try_again? do
        puts "Event not found for #{event_date.strftime('%B %d, %Y')}. Please enter a valid date."
      end

      return false
    else
      selected_event = EventDisplay.display_events_with_index_with_output(filtered_events)
    end

    [false, filtered_events, selected_event]
  end

  def delete_event(event_date, filtered_events, selected_event)
    # binding.pry

    @events[event_date.year][event_date.month][event_date.day].delete(filtered_events[selected_event - 1]) # array
    true
  end

  def display_events_by_month_input(year, month)
    month_events = @events.dig(year, month)

    puts 'There are currently no events in this month!' if month_events.empty?

    month_events
  end

  def get_date_events(event_date)
    @events.dig(event_date.year, event_date.month, event_date.day)
  end

  def display_events_by_date(filtered_events)
    EventDisplay.display_events_with_index(filtered_events)
  end

  def display_all_events
    puts `clear`

    if @events.size.zero?
      puts 'There are currently no events in your calender!'
      return @events
    end

    print 'Title'.ljust(50), "Date\n"
    puts '-' * $TITLE_WIDTH
    @events.each do |_, year|
      year.each do |_, month|
        month.each do |_, day|
          day.each do |event|
            EventDisplay.show(event)
          end
        end
      end
    end

    @events
  end
end
