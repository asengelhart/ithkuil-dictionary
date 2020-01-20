require_relative './scraper.rb'

class CLI

  def self.startup
    Scraper.load_dictionary
    intro_menu
  end

  def self.intro_menu
    puts <<~MENU


    Welcome to the Ithkuil Lexicon CLI Interface!
    Please choose from the following options:
    1. Search for a root word by its English translation
    2. Search for the English translation(s) of a root by phonetic value
    3. Exit
    Enter your choice here:
    MENU
    
    selection = gets.strip.to_i
    if selection == 1
      ask_translation
    elsif selection == 2
      ask_phonetic_value
    elsif selection == 3
      goodbye
    else
      puts "Invalid selection, please try again."
      intro_menu
    end
  end

  def self.ask_translation
    puts "Enter an English translation here:"
    entry = gets.strip
    result_hash = Scraper.search_by_translation(entry)
    if result_hash.all?{|key, array| array.size == 0}
      puts "No results found."
    else
      results_array = []
      count = 1
      if result_hash[:translation_eq].count > 0
        puts "The following roots' translation exactly matches your input:"
        result_hash[:translation_eq].each do |root| 
          puts "#{count}. -#{root.value}- \"#{root.translation}\""
          results_array << root
          count += 1
        end
      end
      if result_hash[:stems_eq].count > 0
        puts "The following roots' stems exactly match your input:"
        result_hash[:stems_eq].each do |root|
          puts "#{count}. -#{root.value}- \"#{root.translation}\""
          results_array << root
          count += 1
        end
      end
      if result_hash[:translation_contains].count > 0
        puts "The following roots' translations contain your input:"
        result_hash[:translation_contains].each do |root|
          puts "#{count}. -#{root.value}- \"#{root.translation}\""
          results_array << root
          count += 1
        end
      end
      if result_hash[:stems_contain].count > 0
        puts "The following roots' stems contain your input:"
        result_hash[:stems_contain].each do |root|
          puts "#{count}. -#{root.value}- \"#{root.translation}\""
          results_array << root
          count += 1
        end
      end

      puts "Please enter your selection:"
      input_num = gets.strip.to_i
      until (1..count).include?(input_num)
        puts "Invalid selection"
        input_num = gets.strip.to_i
      end
      display_root(results_array[input_num - 1])
      intro_menu
    end
  end

  def self.ask_phonetic_value
    puts "Please enter a phonetic value."
    puts "Note: you may need to use Character Map or a similar program to enter special characters."
    puts "Enter value here: "
    input_value = gets.strip.upcase
    result = Scraper.search_by_phonetic_value(input_value)
    if result
      display_root(result)
    else
      puts "No such root found."
    end
    intro_menu
  end

  def self.display_root(root)
    puts "-#{root.value}- = #{root.translation.strip}"
    puts "Derived from: -#{root.base_root.value}- = #{root.base_root.translation.strip}" if root.is_a?(DerivedRoot)
    root.patterns.each do |designation, pattern_array|
      puts (designation == :informal ? "Informal patterns:" : "Formal patterns")
      pattern_array.each do |pattern|
        puts "Pattern #{pattern.pattern_num}:"
        pattern.stems.each_with_index {|stem, index| puts "#{index + 1}. #{stem}"}
      end
    end
  end

  def self.goodbye
    puts <<-GOODBYE
    Thank you for using!
    The Ithkuil language was created by John Quijada, who is not associated with this project.
    For more information, or a complete grammar, visit www.ithkuil.net.
    GOODBYE

  end
end