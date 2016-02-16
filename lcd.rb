
class LCD
	attr_accessor :scale
	attr_reader :values, :output
	DISPLAY_GRID =[
		[1, 3, 0 ,3 ,1], #0
		[0, 2, 0, 2, 0], #1
		[1, 2 ,1 ,1, 1], #2
		[1, 2, 1, 2, 1], #3
		[0, 3, 1, 2, 0], #4
		[1, 1, 1, 2, 1], #5
		[1, 1, 1, 3, 1], #6
		[1, 2, 0, 2 ,0], #7
		[1, 3, 1 ,3, 1], #8
		[1, 3, 1, 2, 1], #9
	]
	HORIZONTAL_CHARACTER = "-"
	VERTICAL_CHARACTER = "|"
	VALID_CHARACTERS = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

	def initialize
		#defaults
		@scale = 2
		@values = ""
		@output = ""
	end

	def to_s
		@output
	end

	def is_valid? to_check
		remove_invalid(to_check).length == to_check.length
	end

	def remove_invalid to_check
		clean = ""
		to_check = to_check.to_s
		to_check.each_char do |char| 
			 clean += char if VALID_CHARACTERS.include?( char)
		end

		clean
	end

	def values= to_display
		@values = remove_invalid( to_display)
	end

	def display
		print @output
	end

	def display to_display
		self.values = to_display
		print update_output
	end

	def update_output
		@output = ""
		return @output if @values.empty?
		# horizontal always has space left and rightmost
		#[ top horizontal, top vertical, mid horizontal, bottom vertical, bottom horizontal]
		#[none/all, left/right/all, none/all, left/right/all, none/all]

		#adapt for scale
		number_of_lines = (scale * 2)  + 3 # each scale affects 2 verticals, add 3 for horizontals
		last_line = number_of_lines - 1 #0 based
		mind_line = scale + 1 #height of one vertical and first horizontal line, 0 based

		display_values = []
		number_of_lines.times { |line| display_values << "" } #create empty lines
		horizontal_slices = [ " #{' ' * scale} ", # " \s "
			" #{HORIZONTAL_CHARACTER * scale} "] # ie " - "
		vertical_slices = [ " #{' ' *  scale} ", # " \s "
			"#{VERTICAL_CHARACTER}#{' ' * scale} ", " #{' ' * scale}#{VERTICAL_CHARACTER}",  #ie  "|\s ", " \s|",
			"#{VERTICAL_CHARACTER}#{' ' * scale}#{VERTICAL_CHARACTER}"] #ie  "|\s|"

		#puts "scale: #{scale}, lines: #{number_of_lines}, values:#{@values}, last_line:#{last_line}, mind_line:#{mind_line}"
		#puts horizontal_slices.inspect
		#puts vertical_slices.inspect

		#convert from values to display text via display grid
		#character by character, appending
		@values.each_char do |char|

			char_on_grid = DISPLAY_GRID[char.to_i]
			layer = 0 #top horizontal, top vertical, mid horizontal, bottom vertical, bottom horizontal

			number_of_lines.times do |line|
				display_values[line] += " " unless display_values[line].empty? #add spacing

				#puts "line: #{line}, layer:#{layer}, out:#{display_values}"

				#convert display_grid to string
				if layer.even?
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

		#work line by line
		number_of_lines.times do |line|
			@output += display_values[line]
			@output += "\n"
		end
		@output.chomp!( "\n") #remove trailing 

		@output
	end

end
