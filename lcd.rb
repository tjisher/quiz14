
class LCD
	attr_accessor :scale
	attr_reader :values, :output

	def initialize
		#defaults
		@scale = 1
		@values = ""
		@output = ""
	end

	def to_s
		@output
	end

	def values= to_display
		#validate
		#convert to string
		@values = to_display
	end

	def update_output
		@output = ""
		return @output if @values.empty?
		#assume scale 1
		# horizontal always has space left and rightmost
		#[ horizontal, vertical, horizontal, vertical, horizontal]
		#[none/all, left/right/all, none/all, left/right/all, none/all]
		display_grid =[
				[1, 3, 0 ,3 ,1], #0
				[0, 2, 0, 2, 0], #1
				[1, 2 ,2 ,1, 1], #2
				[1, 2, 1, 2, 1], #3
				[0, 3, 1, 2, 0], #4
				[1, 1, 1, 2, 1], #5
				[1, 1, 1, 2, 1], #6
				[1, 2, 0, 2 ,0], #7
				[1, 3, 1 ,3, 1], #8
				[1, 3, 1, 2, 1], #9
			]
		#
		display_values = [ "", "", "", "", ""]

		#convert from values to display text via display grid
		#character by character
		@values.each_char do |val|
			grid = display_grid[val.to_i]
			5.times do |line|
				display_values[line] += " " unless display_values[line].empty? #add spacing

				if line.even?
					#horizontal
					display_values[line] += [ "    ", " -- "][ grid[line]]
				else	
					#vertival
					display_values[line] = [ "    ", "|   ", "   |", "|  |"][ grid[line]]
				end
			end
		end

		#work line by line
		5.times do |line|
			@output += display_values[line]
			@output += "\n" unless line == 4 #dont do for last line
		end

		@output
	end

end
