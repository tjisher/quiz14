#ToC
# LCD Class
# Console Runner

require 'Time'

## LCD Class
# converts characters to simplified 5 layer grid
# encoding details:
# => [top horizontal, top vertical, mid horizontal, bottom vertical, bottom horizontal]
# => [none/all, left/right/all, none/all, left/right/all, none/all] 
# => note: horizontal always has space left and rightmost ie " -- "
class LCD
	attr_accessor :scale, :display_grid, :horizontal_character, :vertical_character
	attr_reader :values, :output, :lodger
	DISPLAY_GRID_DEFAULT = {
		"0" => [1, 3, 0 ,3 ,1],
		"1" => [0, 2, 0, 2, 0],
		"2" => [1, 2 ,1 ,1, 1], 
		"3" => [1, 2, 1, 2, 1], 
		"4" => [0, 3, 1, 2, 0], 
		"5" => [1, 1, 1, 2, 1],
		"6" => [1, 1, 1, 3, 1], 
		"7" => [1, 2, 0, 2 ,0],
		"8" => [1, 3, 1 ,3, 1], 
		"9" => [1, 3, 1, 2, 1],
		":" => [0, 0, 0, 0, 0],
	}
	HORIZONTAL_CHARACTER_DEFAULT = "-"
	VERTICAL_CHARACTER_DEFAULT = "|"
	SPECIAL_CHARACTER = "."
	SCALE_DEFAULT = 2

	def initialize
		#defaults
		@lodger = []
		@scale = SCALE_DEFAULT
		@display_grid = DISPLAY_GRID_DEFAULT
		@vertical_character = VERTICAL_CHARACTER_DEFAULT
		@horizontal_character = HORIZONTAL_CHARACTER_DEFAULT
		@output = ""
		@values = ""
	end

	def to_s
		@output
	end

	def valid_characters
		@display_grid.keys
	end

	def is_valid? to_check
		remove_invalid(to_check).length == to_check.length
	end

	def remove_invalid to_check
		clean = ""
		return to_check.strftime( "%H:%M") if to_check.is_a?(Time) #Time is already valid

		to_check = to_check.to_s
		to_check.each_char do |char| 
			 clean += char if valid_characters.include?( char)
		end

		clean
	end

	def values= to_display
		@values = remove_invalid( to_display)
	end

	def display to_display=:use_old_value
		if to_display == :use_old_value
			print @output
		else
			self.values = to_display 
			print update_output
		end
	end

	def update_output
		@output = ""
		return @output if @values.empty?

		#adapt for scale
		number_of_lines = (@scale * 2)  + 3 # each scale affects 2 verticals, add 3 for horizontals
		last_line = number_of_lines - 1 #0 based
		mind_line = @scale + 1 #height of one vertical and first horizontal line, 0 based

		display_values = []
		number_of_lines.times { |line| display_values << "" } #create empty lines

		horizontal_slices = [ " #{' ' * @scale} ", # " \s "
			" #{@horizontal_character * @scale} "] # ie " - "
		vertical_slices = [ " #{' ' *  @scale} ", # " \s "
			"#{@vertical_character}#{' ' * @scale} ", " #{' ' * @scale}#{@vertical_character}",  #ie  "|\s ", " \s|",
			"#{@vertical_character}#{' ' * @scale}#{@vertical_character}"] #ie  "|\s|"
		special_slices = [ " ", "#{SPECIAL_CHARACTER}"] #ie "\s", "."

		#convert from values to display text via display grid
		#character by character, appending
		@values.each_char do |char|

			char_on_grid = @display_grid[char]
			layer = 0 #top horizontal, top vertical, mid horizontal, bottom vertical, bottom horizontal

			number_of_lines.times do |line|
				display_values[line] += " " unless display_values[line].empty? #add spacing

				#convert display_grid to string
				if char == ":"
					#special charaters, dont respect convention
					if line == (mind_line - 1) || line == (mind_line + 1)
						#only output on either side of mid line
						display_values[line] +=  special_slices[1]
					else
						display_values[line] +=  special_slices[0]
					end
				elsif layer.even?
					#horizontal, strings already scaled
					display_values[line] += horizontal_slices[ char_on_grid[layer]]
				else	
					#vertical, parent loop copes with scaling
					display_values[line] += vertical_slices[ char_on_grid[layer]]
				end

				#switch to next layer if needed
				if line == 0 ||  line == mind_line
					#just done a horizontal layer next must be vertical
					layer += 1
				elsif line == (last_line - 1) ||line == (mind_line - 1)
					#next layer is horizontal
					layer += 1
				end

			end
		end

		#convert into single string
		@output = display_values.join( "\n")
		@output += "\n" unless @output.empty? #add trailing new line

		@lodger << { values: @values, scale: @scale, finished_at: Time.now, output: @output }
		@output
	end

end

#check if ran from console, provides no help if called without arguments
#respends to lcd.rb 6789 or lcd.rb -s 1 6789
#  <payload>
# -s <scale> <payload>
# optional arguments -s <scale integer>
# simple implementation order dependent
# scale aggresively turned into integer, ignored if match default
unless ARGV.empty?

	#check if scale parameter sent with a possible payload
	if ARGV[0] == "-s" && ARGV.size == 3
		scale_possible = ARGV[1].to_i

		if scale_possible > 0 && scale_possible != LCD::SCALE_DEFAULT
			scale = scale_possible
		end
	end

	lcd = LCD.new
	lcd.scale = scale if scale
	lcd.display ARGV.last

end
