require 'date'

module EventValidation
  def self.validated_boolean_input
    correct_boolean_inputs = %w[yes no y n]
    boolean_input = gets.strip&.downcase # taking user input

    until correct_boolean_inputs.include?(boolean_input)
      print 'Invalid input. Choose (Yes/No || Y/N)! : '
      boolean_input = gets.strip&.downcase
    end
    %w[yes y].include?(boolean_input)
  end

  def self.validated_numeric_input(range)
    begin
      numeric_input = Integer(gets)
      until range === numeric_input
        print "Invalid input. Choose between (#{range.first} - #{range.last}): "
        numeric_input = Integer(gets)
      end
    rescue ArgumentError
      print "Invalid input. Choose between (#{range.first} - #{range.last}): "
      retry
    end
    numeric_input
  end

  def self.validated_year_input
    print 'Enter Year: '
    validated_numeric_input(1..9999)
  end

  def self.validated_month_input
    months = Date::MONTHNAMES.map { |item| item.nil? ? nil : item.downcase }
    str_input = string_input { 'Name of the Month (January/February): ' }
    str_input = string_input do
      'Type a valid Month Name (January/February): '
    end until months.include?(str_input.downcase)
    months.index(str_input.downcase)
  end

  def self.validated_date_of_month(month_number, year)
    months = Date::MONTHNAMES
    days_in_month = Date.new(year, month_number, -1).day
    print "Date of month #{months[month_number]}: "
    validated_numeric_input(1..days_in_month)
  end

  def self.string_input
    print yield

    str_input = gets.chomp.strip

    while str_input.empty?
      puts "Invalid input, can't be empty!"
      print yield
      str_input = gets.chomp.strip
    end
    str_input
  end
end
