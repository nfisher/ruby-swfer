#!/opt/local/bin/ruby -w

class SwferTest < Test::Unit::TestCase
	def test_failure
		assert( true, 'Test failure' )
	end
end
