require_relative 'event_validation'
require_relative 'event'
$TITLE_WIDTH = 70

module EventDisplay
  include EventValidation

  def self.add_event
    title = EventValidation.string_input { 'Enter Title: ' }
    year = EventValidation.validated_year_input
    month = EventValidation.validated_month_input
    date = EventValidation.validated_date_of_month(month, year)

    {
      title: title,
      year: year,
      month: month,
      date: date
    }
  end

  def self.edit_attribute_values
    puts '1. Edit Title'
    puts '2. Edit Date'
    print 'Select an option from above: '

    selected_option = EventValidation.validated_numeric_input(1..2)

    result = {}
    if selected_option == 1
      title = EventValidation.string_input { 'Enter New Title: ' }
      result['attr_to_edit'] = 'title'
      result['value'] = title
    else
      date = read_date
      result['attr_to_edit'] = 'date'
      result['value'] = date
    end

    result
  end

  def self.read_date
    puts 'Enter Date of the event'
    year = EventValidation.validated_year_input
    month = EventValidation.validated_month_input
    date = EventValidation.validated_date_of_month(month, year)
    Date.new(year, month, date)
  end

  def self.display_events_by_month(month_events)
    month_events.each do |_, day_events|
      next unless day_events.is_a?(Array) # incase array is empty, could have used safe nav as well

      puts `clear`

      print 'No.'.ljust(5), 'Title'.ljust(50), "Date\n"
      puts '-' * $TITLE_WIDTH
      day_events.each.with_index(1) do |event, index|
        # print "#{index+1}".ljust(5), EventDisplay.show(event)
        print "#{index}".ljust(5), "#{event.title}".ljust(50), "#{event.date.strftime('%B %d, %Y')}\n"
      end
    end
  end

  def self.try_again?
    yield

    print 'Try Again (Yes/No): '
    return false unless EventValidation.validated_boolean_input

    true
  end

  def self.display_events_with_index_with_output(events)
    print 'No.'.ljust(5), 'Title'.ljust(50), "Date\n"
    puts '-' * $TITLE_WIDTH

    events.each.with_index(1) do |event, index|
      print "#{index}.".ljust(5), "#{event.title}".ljust(50), "#{event.date.strftime('%B %d, %Y')} \n"
    end

    print 'Select an event number from Above to Edit: '
    EventValidation.validated_numeric_input(1..events&.length)
  end

  def self.display_events_with_index(events)
    print 'No.'.ljust(5), 'Title'.ljust(50), "Date\n"
    puts '-' * $TITLE_WIDTH

    events.each.with_index(1) do |event, index|
      print "#{index}.".ljust(5), "#{event.title}".ljust(50), "#{event.date.strftime('%B %d, %Y')} \n"
    end
  end

  def self.show(event)
    event.show_event
  end
end
