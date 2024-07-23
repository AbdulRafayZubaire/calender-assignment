require_relative 'event_collection'
require_relative 'event_display'
require_relative 'event_validation'
require 'date'

class Calender
  include EventValidation
  include EventDisplay
  attr_accessor :events

  def initialize
    @events_collection = EventCollection.new
  end

  def find_month_start_date(year, month)
    Date.new(year, month, 1).strftime('%A')
  end

  def find_month_last_date(year, month)
    Date.new(year, month, -1).day
  end

  def display_calender_title(month, year)
    puts '-' * $TITLE_WIDTH
    puts "#{Date::MONTHNAMES[month]}, #{year}".center($TITLE_WIDTH)
    puts '-' * $TITLE_WIDTH
    puts "\n"
  end

  def retrieve_menu
    ['View Calender', 'Add Event', 'Edit Event', 'View Details of an Event', 'View all events of a month',
     'View all events on a Date', 'View all Events', 'Delete an Event', 'Quit']
  end

  def render_calender(first_date_month, last_date_month, day_start_index, events_collection, year, month)
    (0..4).to_a.each do |row|
      puts '-' * $TITLE_WIDTH
      (0..6).to_a.each_with_index do |_col, index|
        if (index >= day_start_index || row.positive?) && (first_date_month <= last_date_month)
          print "#{first_date_month} (#{events_collection.events.dig(year, month,
                                                                     first_date_month)&.length})".ljust(10)
          first_date_month += 1
        else
          print ' '.ljust(10)
        end
      end
      puts # endline
    end
    puts '-' * $TITLE_WIDTH
  end

  def display_calender(month = Date.today.month, year = Date.today.year)
    display_calender_title(month, year)

    Date::DAYNAMES.each do |day| # days in a week
      print "#{day}".ljust(10)
    end
    puts "\n\n" # endline

    month_start_day = find_month_start_date(year, month)
    day_start_index = Date::DAYNAMES.index(month_start_day)

    first_date_month = 1
    last_date_month = find_month_last_date(year, month)

    # loop to render calender
    render_calender(first_date_month, last_date_month, day_start_index, @events_collection, year, month)
  end

  def display_menu_primary
    menu_arr = retrieve_menu

    loop do
      puts "\n\n"
      puts '-' * $TITLE_WIDTH
      puts 'Main menu'.center($TITLE_WIDTH)
      puts '-' * $TITLE_WIDTH
      menu_arr.each.with_index(1) do |option, index|
        puts "#{index}." " #{option}"
      end

      print 'Select an option from above: '
      selected_option = EventValidation.validated_numeric_input(1..menu_arr.length)

      case selected_option
      when 1
        puts `clear`
        print 'Display Current Month Calender? (Yes/No): '

        if EventValidation.validated_boolean_input
          display_calender
        else
          year = EventValidation.validated_year_input
          month = EventValidation.validated_month_input
          display_calender(month, year)
        end
      when 2
        user_input = EventDisplay.add_event
        @events_collection.add_event(user_input)
        puts `clear`
        puts '--------- Successfully Added an event ---------'.center($TITLE_WIDTH)
      when 3
        loop do
          date = EventDisplay.read_date # taking date input from user
          retry_iteration, selected_event = @events_collection.edit_event_input(date)

          next if retry_iteration == true

          break unless selected_event # returns to main menu if no selected event

          attribute = EventDisplay.edit_attribute_values
          @events_collection.edit_event(selected_event, date, attribute)

          puts `clear`
          puts ' Successfully Edited an event '.center($TITLE_WIDTH, '-')
          break
        end
      when 4
        event_date = EventDisplay.read_date
        title = EventValidation.string_input { 'Title: ' }
        @events_collection.view_event(title, event_date)
      when 5
        year = EventValidation.validated_year_input
        month = EventValidation.validated_month_input
        month_events = @events_collection.display_events_by_month_input(year, month)
        EventDisplay.display_events_by_month(month_events)
      when 6
        loop do
          event_date = EventDisplay.read_date

          filtered_events = @events_collection.get_date_events(event_date)

          if filtered_events.length.zero?
            next if EventDisplay.try_again? do
              puts "Event not found for #{event_date.strftime('%B %d, %Y')}. Please enter a valid date."
            end

            break
          else
            @events_collection.display_events_by_date(filtered_events)
          end
          break
        end
      when 7
        @events_collection.display_all_events
      when 8
        loop do
          event_date = EventDisplay.read_date
          retry_iteration, filtered_events, selected_event = @events_collection.delete_event_input(event_date)

          next if retry_iteration == true

          break unless filtered_events && selected_event # returns to main menu if no selected event

          @events_collection.delete_event(event_date, filtered_events, selected_event)

          puts `clear`
          puts ' Successfully Deleted an event '.center($TITLE_WIDTH, '-')
          break
        end
      end

      break if selected_option == 9
    end
  end
end

calender = Calender.new
calender.display_menu_primary
