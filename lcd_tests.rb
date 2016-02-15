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
			"Should auto convert to string and output empty string as default"
	end

	def test_output_single
		lcd = LCD.new 
		lcd.values = "0"
		zero = %( -- 
|  |
    
|  |
 -- )

		assert_equal  zero, lcd.output,
			"Output of 0 does not match expected"
	end

end