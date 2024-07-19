require_relative "Validation.rb"
require_relative "Event.rb"

module EventDisplay
  include Validation
  
  def self.add_event
    title = Validation.string_input {"Enter Title: "}
    year = Validation.validated_year_input()
    month = Validation.validated_month_input()
    date = Validation.validated_date_of_month(month, year)

    Event.new(title, Date.new(year, month, date))
  end

  def self.edit_event(event)

    puts "1. Edit Title"
    puts "2. Edit Date"
    puts "Select an option from above: "

    selected_option = Validation.validated_numeric_input(1..2)

    if selected_option == 1
      event.title = Validation.string_input {"Enter New Title: "}
      true
    else
      event.date = get_date
      event
    end
  end

  def self.get_date
    puts "Enter Date of the event"
    year = Validation.validated_year_input
    month = Validation.validated_month_input()
    date = Validation.validated_date_of_month(month, year)
    Date.new(year, month, date)
  end

  def self.show(event)
    event.show_event
  end
end