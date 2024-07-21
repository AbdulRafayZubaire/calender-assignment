require_relative 'event_collection'
require_relative 'validation'
require 'date'

class Calender
  include Validation
  attr_accessor :events

  def initialize
    @events_collection = EventCollection.new
  end

  def display_calender(month = Date.today.month, year = Date.today.year)
    puts '-' * 70
    puts "#{Date::MONTHNAMES[month]}, #{year}".center(70)
    puts '-' * 70
    puts "\n"
    Date::DAYNAMES.each do |day|
      print "#{day}".ljust(10)
    end
    puts "\n\n" # endline

    month_start_day = Date.new(year, month, 1).strftime('%A')
    day_start_index = Date::DAYNAMES.index(month_start_day)

    first_date_month = 1
    last_date_month = Date.new(year, month, -1).day

    (0..4).to_a.each do |row|
      puts  '-' * 70
      (0..6).to_a.each_with_index do |_col, index|
        if (index >= day_start_index || row.positive?) && (first_date_month <= last_date_month)

          print "#{first_date_month} (#{@events_collection.events.dig(year, month,
                                                                      first_date_month)&.length})".ljust(10)
          first_date_month += 1
        else
          print ' '.ljust(10)
        end
      end
      puts # endline
    end
    puts '-' * 70
  end

  def display_menu_primary
    menu_arr = ['View Calender', 'Add Event', 'Edit Event', 'View Details of an Event', 'View all events of a month',
                'View all events on a Date', 'View all Events', 'Delete an Event', 'Quit']

    loop do
      puts "\n\n"
      puts '-' * 70
      puts 'Main menu'.center(70)
      puts '-' * 70
      menu_arr.each_with_index do |option, index|
        puts "#{index + 1}" " #{option}"
      end

      print 'Select an option from above: '
      selected_option = Validation.validated_numeric_input(1..menu_arr.length)

      case selected_option
      when 1
        puts `clear`
        print 'Display Current Month Calender? (Yes/No): '

        if Validation.validated_boolean_input
          display_calender
        else
          year = Validation.validated_year_input
          month = Validation.validated_month_input
          display_calender(month, year)
        end
      when 2
        @events_collection.add_event
        puts `clear`
        puts '--------- Successfully Added an event ---------'.center(70)
      when 3
        edited = @events_collection.edit_event
        puts `clear`
        puts ' Successfully Edited an event '.center(70, '-') if edited
      when 4
        @events_collection.view_event
      when 5
        @events_collection.display_events_by_month
      when 6
        @events_collection.display_events_by_date
      when 7
        @events_collection.display_all_events
      when 8
        deleted = @events_collection.delete_event
        puts `clear`
        puts ' Successfully Deleted an event '.center(70, '-') if deleted
      end

      # @events_collection.display_all_events
      break if selected_option == 9
    end
  end
end

calender = Calender.new
calender.display_menu_primary
