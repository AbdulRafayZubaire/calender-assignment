require "date"

module Validation
  def self.validated_boolean_input
    correct_boolean_inputs = ["yes", "no", "y", "n"]
    input = gets.strip.downcase # taking user input 

    while !correct_boolean_inputs.include?(input)
      print "Invalid input. Choose (Yes/No || Y/N)! : "
      input = gets.strip.downcase
    end
    (input == "yes" || input == "y") ? true: false
  end

  def self.validated_numeric_input(range)
    input = gets.strip.to_i.truncate
    until range === input
      print "Invalid input. Choose between (#{range.first} - #{range.last}): "
      input = gets.strip.to_i
    end
    return input
  end

  def self.validated_year_input
    print "Enter Year: "
    validated_numeric_input(1..9999)
  end

  def self.validated_month_input
    months = Date::MONTHNAMES.compact.map(&:downcase)
    input = string_input {"Name of the Month (January/February): "}
    until months.include?(input.downcase)
      input = string_input {"Type a valid Month Name (January/February): "}
    end
    return months.index(input.downcase)+1
  end

  def self.validated_date_of_month(month_number, year)
    months = Date::MONTHNAMES.compact
    days_in_month = Date.new(year, month_number, -1).day

    print "Date of month #{months[month_number-1]}: "
    
    selected_date_of_month = validated_numeric_input(1..days_in_month)
    return selected_date_of_month
  end

  def self.string_input
    print yield
    input = gets.chomp.strip
    input
  end
end