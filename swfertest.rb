#!/opt/local/bin/ruby -w

require 'test/unit'

class SwferTest < Test::Unit::TestCase
	def test_failure
		assert( true, 'Test failure' )
	end
end
