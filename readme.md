[![Build Status](https://travis-ci.org/tjisher/quiz14.svg?branch=master)](https://travis-ci.org/tjisher/quiz14)
Extened and adpated


###Orginal Specification
http://rubyquiz.com/quiz14.html
LCD Numbers (#14)
This week's quiz is to write a program that displays LCD style numbers at adjustable sizes.

The digits to be displayed will be passed as an argument to the program. Size should be controlled with the command-line option -s follow up by a positive integer. The default value for -s is 2.

For example, if your program is called with:

``> lcd.rb 012345``

The correct display is:

	 --        --   --        -- 
	|  |    |    |    | |  | |   
	|  |    |    |    | |  | |   
	           --   --   --   -- 
	|  |    | |       |    |    |
	|  |    | |       |    |    |
	 --        --   --        -- 


And for:

``> lcd.rb -s 1 6789``

Your program should print:

	 -   -   -   - 
	|     | | | | |
	 -       -   - 
	| |   | | |   |
	 -       -   - 

Note the single column of space between digits in both examples. For other values of -s, simply lengthen the - and | bars.


###Extended Spec

stage_1

* numeric
* scale
* .to_s

stage_2

* console access
* time ie 13:20
* last output
* last assignment

stage_3

* adaptable character set
* adaptable displayed characters
* alphanumic+time
