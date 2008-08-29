#!/opt/local/bin/ruby -w

require 'test/unit/ui/console/testrunner'
require 'test/unit/testsuite'
require 'swfertest'
require 'swferrecttest'

class SwferTestSuite
	def self.suite
		suite = Test::Unit::TestSuite.new
		suite << SwferTest.suite
		suite << SwferRectTest.suite

		return suite
	end
end

Test::Unit::UI::Console::TestRunner.run( SwferTestSuite )
