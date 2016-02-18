##ToC
# LCD Class

require 'Time'

## LCD Class
# converts characters to simplified 5 layer grid, scaleable
#
# case sensative
# not implemented characters are ignored, completely invalid entry will return empty string
# works with any object convertable to string
#
# default to_s overides:
# time object specificly ouputs in HH:MM format
#
# key methods:
# display, takes key values are ouputs result to console
# update_output, actual string generation
#
# encoding details:
# top horizontal, top vertical, mid horizontal, bottom vertical, bottom horizontal
# none/all, left/right/all, none/all, left/right/all, none/all
# note: horizontal always has space left and rightmost ie " -- "
class LCD
	attr_accessor :scale, :character_encoding, :horizontal_character, :vertical_character
	attr_reader :values, :output, :logger
	CHARACTER_ENCODING_DEFAULT = {
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
		":" => :special,
	}
	HORIZONTAL_CHARACTER_DEFAULT = "-"
	VERTICAL_CHARACTER_DEFAULT = "|"
	SPECIAL_CHARACTER = "."
	SCALE_DEFAULT = 2

	def initialize
		#defaults
		@logger = []
		@scale = SCALE_DEFAULT
		@character_encoding = CHARACTER_ENCODING_DEFAULT
		@vertical_character = VERTICAL_CHARACTER_DEFAULT
		@horizontal_character = HORIZONTAL_CHARACTER_DEFAULT
		@output = ""
		@values = ""
	end

	#returns the last output
	def to_s
		@output
	end

	#returns array of implemented characters
	def valid_characters
		@character_encoding.keys
	end

	#returns true if all characters are implemented, case sensative
	def is_valid? to_check
		remove_invalid(to_check).length == to_check.length
	end

	#returns string of all implemented characters, case sensative
	def remove_invalid to_check
		clean = ""
		return to_check.strftime( "%H:%M") if to_check.is_a?(Time) #Time is already valid

		to_check = to_check.to_s
		to_check.each_char do |char| 
			 clean += char if valid_characters.include?( char)
		end

		clean
	end

	#update value to be displayed, invalid characters removed
	#does not auto generate response
	def values= to_display
		@values = remove_invalid( to_display)
	end

	#output to console
	#always re-generates output
	#
	#optional parametes
	# to_display, new value to be displayed
	# scale, new scale to be used
	def display to_display=nil, scale=nil
		self.scale = scale if scale
		self.values = to_display if to_display

		print update_output
	end

	#generate new lcd representation
	#returns string with new line characters
	#adds to logger
	def update_output
		@output = ""
		return @output if @values.empty?

		#adapt for scale
		# key line numbers
		number_of_lines = (@scale * 2)  + 3 # each scale affects 2 verticals, add 3 for horizontals
		last_line = number_of_lines - 1 #0 based
		mind_line = @scale + 1 #height of one vertical and first horizontal line, 0 based

		# prepare working container
		display_values = []
		number_of_lines.times { |line| display_values << "" } 

		# generate the possible elements
		horizontal_slices = [ " #{' ' * @scale} ", # " \s "
			" #{@horizontal_character * @scale} "] # ie " - "
		vertical_slices = [ " #{' ' *  @scale} ", # " \s "
			"#{@vertical_character}#{' ' * @scale} ", " #{' ' * @scale}#{@vertical_character}",  #ie  "|\s ", " \s|",
			"#{@vertical_character}#{' ' * @scale}#{@vertical_character}"] #ie  "|\s|"
		special_slices = [ " ", "#{SPECIAL_CHARACTER}"] #ie "\s", "."

		#actual conversion
		#character by character, then line by line, appending
		@values.each_char do |char|

			char_on_grid = @character_encoding[char]
			layer = 0 #top horizontal, top vertical, mid horizontal, bottom vertical, bottom horizontal

			number_of_lines.times do |line|
				display_values[line] += " " unless display_values[line].empty? #add spacing

				#convert the encoding to its segment
				if char_on_grid == :special
					#special charaters, dont respect convention, ie ':'
					if line == (mind_line - 1) || line == (mind_line + 1)
						#only output on either side of mid line
						display_values[line] +=  special_slices[1]
					else
						display_values[line] +=  special_slices[0]
					end
				#normal characters
				elsif layer.even?
					#horizontal, strings already scaled
					display_values[line] += horizontal_slices[ char_on_grid[layer]]
				else	
					#vertical, parent loop copes with scaling
					display_values[line] += vertical_slices[ char_on_grid[layer]]
				end

				#switch to next layer if needed, ie do not increment if need more vericals
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

		@logger << { values: @values, scale: @scale, finished_at: Time.now, output: @output }
		@output
	end

end
