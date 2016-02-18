##ToC
#LCD API Tests

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative 'lcd_api.rb'

include Rack::Test::Methods

class LCDAPITest < MiniTest::Test
	def app
	  Sinatra::Application
	end

	def test_responds_to_index
	    get '/'
	    assert last_response.ok?, 
	    	"should respond to index requests"
	end

end 
