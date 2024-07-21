require 'date'

module Validation
  def self.validated_boolean_input
    correct_boolean_inputs = %w[yes no y n]
    input = gets.strip.downcase # taking user input

    until correct_boolean_inputs.include?(input)
      print 'Invalid input. Choose (Yes/No || Y/N)! : '
      input = gets.strip.downcase
    end
    %w[yes y].include?(input) ? true : false
  end

  def self.validated_numeric_input(range)
    begin
      input = Integer(gets)
      until range === input
        print "Invalid input. Choose between (#{range.first} - #{range.last}): "
        input = Integer(gets)
      end
    rescue ArgumentError
      print "Invalid input. Choose between (#{range.first} - #{range.last}): "
      retry
    end
    input
  end

  def self.validated_year_input
    print 'Enter Year: '
    validated_numeric_input(1..9999)
  end

  def self.validated_month_input
    months = Date::MONTHNAMES.compact.map(&:downcase)
    input = string_input { 'Name of the Month (January/February): ' }
    input = string_input { 'Type a valid Month Name (January/February): ' } until months.include?(input.downcase)
    months.index(input.downcase) + 1
  end

  def self.validated_date_of_month(month_number, year)
    months = Date::MONTHNAMES.compact
    days_in_month = Date.new(year, month_number, -1).day

    print "Date of month #{months[month_number - 1]}: "

    validated_numeric_input(1..days_in_month)
  end

  def self.string_input
    print yield

    input = gets.chomp.strip

    while input.empty?
      puts "Invalid input, can't be empty!"
      print yield
      input = gets.chomp.strip
    end
    input
  end
end
