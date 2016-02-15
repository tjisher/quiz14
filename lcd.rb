
class LCD
	attr_accessor :values, :scale
	attr_reader :output

	def initialize
		#defaults
		@scale = 1
		@values = ""
		@output = ""
	end

	def to_s
		@output
	end
end

