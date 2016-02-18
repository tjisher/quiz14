require_relative 'lcd.rb'

#check if actual request, provides no help if called without arguments
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