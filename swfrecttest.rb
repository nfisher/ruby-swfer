#!/opt/local/bin/ruby -w

require 'test/unit'
require 'swfrect'

class SwfRectTest < Test::Unit::TestCase
	def setup
		@rect = SwfRect.new
	end

	def teardown
		@rect = nil
	end

	def test_required_bytes_for_1bit_datapack
		val = 0b00001000
		assert_equal( 2, @rect.required_bytes(val) )
	end

	def test_required_bytes_for_2bit_datapack 
		val = 0b00010010
		assert_equal( 2, @rect.required_bytes(val) )
	end

	def test_required_bytes_for_16bit_datapack
		val = 0b10000000
		assert_equal( 9, @rect.required_bytes(val) )
	end

	def test_required_bytes_with_all_bits_on
		val = 0b11111111
		assert_equal( 17, @rect.required_bytes(val) )
	end

	def test_required_bytes_with_all_bits_off
		val = 0
		assert_equal( 1, @rect.required_bytes(val) )
	end

	def test_default_frame_byte
		val = 0b01111000
		@rect.required_bytes( val )
		assert_equal( 15, @rect.nbits )
	end
end
