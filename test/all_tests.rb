#!/opt/local/bin/ruby -w

require 'test/unit/ui/console/testrunner'
require 'test/unit/testsuite'
require 'test/test_helper.rb'

Dir['**/*_test.rb'].each { |test_case| require test_case }

class SwferTestSuite
	def self.suite
		suite = Test::Unit::TestSuite.new "Ruby SWFer"
		suite << SwferTest.suite
		suite << SwfRectTest.suite

		return suite
	end
end

Test::Unit::UI::Console::TestRunner.run( SwferTestSuite )
