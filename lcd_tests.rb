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
		lcd.scale = 2

		assert_equal 2, lcd.scale,
			"Scale should be saved and retrieved properly"
	end

	def test_assignment_scale_default
		lcd = LCD.new 

		assert_equal 1, lcd.scale,
			"Scale default should be 1"
	end

	#Output
	def test_responds_to_to_s
		lcd = LCD.new 

		refute_match /#\<LCD:/, lcd.to_s, 
			"to_s opertaion should be appropiate"
		assert_equal  "", lcd.to_s,
			"Output empty string as default"
	end

	def test_output_single
		lcd = LCD.new 
		lcd.values = "0"
		lcd.update_output
		zero =  <<-STR
 -- 
|  |
    
|  |
 -- 
STR

		assert_equal  zero.chomp("\n"), lcd.output,
			"Output of 0 does not match expected"
	end

	def test_output_two_values
		lcd = LCD.new 
		lcd.values = "01"
		lcd.update_output
		two_numbers = <<-STR
 --      
|  |    |
         
|  |    |
 --      
STR

		assert_equal  two_numbers.chomp("\n"), lcd.output,
			"Output of two values '01' does not match expected"
	end

	def test_output_all_numbers
		lcd = LCD.new 
		lcd.values = "0123456789"
		lcd.update_output
		all_numbers = <<-STR
 --        --   --        --   --   --   --   -- 
|  |    |    |    | |  | |    |       | |  | |  |
           --   --   --   --   --        --   -- 
|  |    | |       |    |    | |  |    | |  |    |
 --        --   --        --   --        --   -- 
STR
		assert_equal  all_numbers.chomp("\n"), lcd.output,
			"Output of 0123456789 does not match expected"
	end

end