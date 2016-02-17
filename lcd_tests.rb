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

		assert_equal 2, LCD::SCALE_DEFAULT,
			"Scale default should be 2 and be present in SCALE_DEFAULT constant"
	end

	def test_assignment_string_invalid
		lcd = LCD.new 
		lcd.values = "01234a"

		assert_equal "01234", lcd.values, 
			"Invalid values should be ignored"
	end

	def test_is_valid
		lcd = LCD.new 

		assert_equal true, lcd.valid_characters.include?( "1"), 
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

		assert_equal  zero, lcd.output,
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

		assert_equal  zero, lcd.output,
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

		assert_equal  two_numbers, lcd.output,
			"Output of two values '01' scale 1 does not match expected"
	end

	def test_output_two_values
		lcd = LCD.new 
		lcd.values = "01"
		lcd.update_output
		zero_one =  <<-STR
 --      
|  |    |
|  |    |
         
|  |    |
|  |    |
 --      
STR

		assert_equal  zero_one, lcd.output,
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
		assert_equal  all_numbers, lcd.output,
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
		assert_equal  all_numbers, lcd.output,
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
		assert_equal  all_numbers, lcd.output,
			"Output of 012345 does not match expected"
	end


	#Time Testing
	def test_assignment_time
		lcd = LCD.new 
		lcd.values = "12:34"

		assert_equal "12:34", lcd.values, 
			"Time style values (12:34) should be accepted as strings"
	end

	def test_assignment_time_object
		lcd = LCD.new 
		t = Time.now
		lcd.values = t

		assert lcd.values.match( /\d\d:\d\d/),
			"Time objects should be accepted and return simple time ie '12:34'"
	end

	def test_assignment_time_object_format
		lcd = LCD.new 
		t = Time.new( 2000, 10, 31, 23, 59)
		lcd.values = t

		assert_equal "23:59", lcd.values, 
			"Time from objects should be in 24hr format"

		t = Time.new( 2000, 10, 31, 01, 59)
		lcd.values = t

		assert_equal "01:59", lcd.values, 
			"Time from objects should be padded"
	end

	def test_assignment_time_object_local
		lcd = LCD.new 
		t = Time.now
		lcd.values = t

		assert_equal t.strftime( "%H:%M"), lcd.values, 
			"Time objects should be accepted and return local padded time values in 24hour clock ie '01:01' or '23:59'"
	end

	def test_output_time_with_semicolon
		lcd = LCD.new 
		lcd.values = "67:89"
		lcd.scale = 1
		lcd.update_output
		all_numbers = <<-STR
 -   -     -   - 
|     | . | | | |
 -         -   - 
| |   | . | |   |
 -         -   - 
STR
		assert_equal  all_numbers, lcd.output,
			"Output of 67:89 scale 1 does not match expected"
	end

	#Lodger
	def test_lodger_active
		lcd = LCD.new 
		lcd.values = "01"
		lcd.update_output
		lcd.values = "02"
		lcd.update_output

		assert_equal 2, lcd.lodger.count,
			"Lodger should record values"
	end

	def test_lodger_data
		lcd = LCD.new 
		lcd.values = "01"
		lcd.update_output
		zero_one =  <<-STR
 --      
|  |    |
|  |    |
         
|  |    |
|  |    |
 --      
STR

		assert_equal "01", lcd.lodger.last[:values],
			"Lodger should record the values given for a job"

		assert lcd.lodger.last[:finished_at].is_a?(Time),
			"Lodger should record time job finished"

		assert_equal zero_one, lcd.lodger.last[:output],
			"Lodger should record the output given for a job"

		assert_equal 2, lcd.lodger.last[:scale],
			"Lodger should record the scale given for a job"
	end

	#Adapatable Character Set
	def test_displayed_characters
		lcd = LCD.new

		assert !lcd.vertical_character.empty?,
			"Verticle Character should be accesible and present"

		assert !lcd.horizontal_character.empty?,
			"Horizontal Character should be accesible and present"

		assert_equal "|", lcd.vertical_character,
			"Verticle Character should default to '|'"

		assert_equal "-", lcd.horizontal_character,
			"Horizontal Character should default to '-'"
	end

	def test_displayed_characters_change
		lcd = LCD.new
		lcd.vertical_character = '@'
		lcd.horizontal_character = '='

		assert_equal "@", lcd.vertical_character,
			"Verticle Character should changable"

		assert_equal "#", lcd.horizontal_character,
			"Horizontal Character should changable"
	end

	def test_displayed_characters_output
		lcd = LCD.new
		lcd.vertical_character = '@'
		lcd.horizontal_character = '='
		lcd.values = "01"
		lcd.update_output
		zero_one =  <<-STR
 ==      
@  @    @
@  @    @
         
@  @    @
@  @    @
 ==      
STR

		assert_equal zero_one, lcd.output,
			"Newly set Horizontal/Verticle Character should output"
	end

	def test_characters_accessible
		lcd = LCD.new

		assert lcd.display_grid.count > 0,
			"Character Encoding should be accessible and pre-populated"
	end


	def test_characters_overrideable
		lcd = LCD.new
		lcd.display_grid = nil

		assert lcd.display_grid.nil?,
			"Character Encoding should be overrideable"

		one_encoded = { "1" => [0, 2, 0, 2, 0]}
		lcd.display_grid = one_encoded

		assert_equal one_encoded, lcd.display_grid,
			"Character Encoding should accept properly formed hashes"
	end

	def test_characters_updated_output
		lcd = LCD.new
		one_encoded = { "1" => [0, 2, 0, 2, 0]}
		lcd.display_grid = one_encoded

		lcd.values = "1"
		lcd.update_output
		one =  <<-STR
    
   |
   |
    
   |
   |
    
STR
		assert_equal one_encoded, lcd.display_grid,
			"Character Encoding should accept properly formed hashes"
		assert_equal one, lcd.output,
			"Changed Character Encoding should still output correctly"

		lcd.values = "01"
		lcd.update_output

		assert_equal one, lcd.output,
			"Changed Character Encoding should cope with missing characters"
	end

end
