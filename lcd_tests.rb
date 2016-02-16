require './lcd.rb'
require 'minitest/autorun'

class LCDTest < MiniTest::Unit::TestCase

	#Assignment 
	def test_assignment_string
		lcd = LCD.new 
		lcd.values = "01234"

		assert_equal "01234", lcd.values, 
			"Values to display should be saved and retrieved properly"
	end

	def test_assignment_scale
		lcd = LCD.new 
		lcd.scale = 1

		assert_equal 1, lcd.scale,
			"Scale should be saved and retrieved properly"
	end

	def test_assignment_scale_default
		lcd = LCD.new 

		assert_equal 2, lcd.scale,
			"Scale default should be 2"
	end

	def test_assignment_string_invalid
		lcd = LCD.new 
		lcd.values = "01234a"

		assert_equal "01234", lcd.values, 
			"Invalid values should be ignored"
	end

	def test_is_valid
		lcd = LCD.new 

		assert_equal true, LCD::VALID_CHARACTERS.include?( "1"), 
			"Valid Characters list should exist and include '1'"

		all_numbers = "0123456789"
		assert (lcd.values = all_numbers).length == all_numbers.length
			"Valid Characters list should contains all numbers"

		assert_equal false, lcd.is_valid?( "01234a"), 
			"is_valid method should report presence of illegal characters"
	end

	def test_assignment_integer
		lcd = LCD.new 
		lcd.values = 10234

		assert_equal "10234", lcd.values, 
			"Integer values should be accepted as strings"
	end


	#Output
	def test_responds_to_to_s
		lcd = LCD.new 

		refute_match /#\<LCD:/, lcd.to_s, 
			"to_s opertaion should be appropiate"
		assert_equal  "", lcd.to_s,
			"Output empty string as default"
	end

	def test_output_single_scaled
		lcd = LCD.new 
		lcd.values = "0"
		lcd.scale = 1
		lcd.update_output
		zero =  <<-STR
 - 
| |
   
| |
 - 
STR

		assert_equal  zero.chomp("\n"), lcd.output,
			"Output of '0' scale 1 does not match expected"
	end

	def test_output_single
		lcd = LCD.new 
		lcd.values = "0"
		lcd.update_output
		zero =  <<-STR
 -- 
|  |
|  |
    
|  |
|  |
 -- 
STR

		assert_equal  zero.chomp("\n"), lcd.output,
			"Output of '0' scaled to 2 does not match expected"
	end

	def test_output_two_values_scaled
		lcd = LCD.new 
		lcd.values = "01"
		lcd.scale = 1
		lcd.update_output
		two_numbers = <<-STR
 -     
| |   |
       
| |   |
 -     
STR

		assert_equal  two_numbers.chomp("\n"), lcd.output,
			"Output of two values '01' scale 1 does not match expected"
	end

	def test_output_two_values
		lcd = LCD.new 
		lcd.values = "01"
		lcd.update_output
		zero =  <<-STR
 --      
|  |    |
|  |    |
         
|  |    |
|  |    |
 --      
STR

		assert_equal  zero.chomp("\n"), lcd.output,
			"Output of two values '01' does not match expected"
	end

	def test_output_all_numbers
		lcd = LCD.new 
		lcd.values = "0123456789"
		lcd.scale = 1
		lcd.update_output
		all_numbers = <<-STR
 -       -   -       -   -   -   -   - 
| |   |   |   | | | |   |     | | | | |
         -   -   -   -   -       -   - 
| |   | |     |   |   | | |   | | |   |
 -       -   -       -   -       -   - 
STR
		assert_equal  all_numbers.chomp("\n"), lcd.output,
			"Output of 0123456789 scale 1 does not match expected"
	end

	def test_output_against_spec_example_scaled
		lcd = LCD.new 
		lcd.values = "6789"
		lcd.scale = 1
		lcd.update_output
		all_numbers = <<-STR
 -   -   -   - 
|     | | | | |
 -       -   - 
| |   | | |   |
 -       -   - 
STR
		assert_equal  all_numbers.chomp("\n"), lcd.output,
			"Output of 6789 scale 1 does not match expected"
	end

	def test_output_against_spec_example
		lcd = LCD.new 
		lcd.values = "012345"
		lcd.update_output
		all_numbers = <<-STR
 --        --   --        -- 
|  |    |    |    | |  | |   
|  |    |    |    | |  | |   
           --   --   --   -- 
|  |    | |       |    |    |
|  |    | |       |    |    |
 --        --   --        -- 
STR
		assert_equal  all_numbers.chomp("\n"), lcd.output,
			"Output of 012345 does not match expected"
	end

end
