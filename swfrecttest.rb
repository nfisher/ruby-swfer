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

	def test_required_bytes_with_bytes_not_set
		assert_equal( nil, @rect.required_bytes )
	end

	def test_nbits_for_1bit_datapack
		val = 0b00001000
		@rect.nbits = val
		assert_equal( 1, @rect.nbits )
	end

	def test_nbits_for_2bit_datapack 
		val = 0b00010010
		@rect.nbits = val
		assert_equal( 2, @rect.nbits )
	end

	def test_nbits_for_16bit_datapack
		val = 0b10000000
		@rect.nbits = val
		assert_equal( 16, @rect.nbits )
	end

	def test_nbits_with_all_bits_on
		val = 0b11111111
		@rect.nbits = val
		assert_equal( 31, @rect.nbits )
	end

	def test_nbits_with_all_bits_off
		val = 0
		@rect.nbits = val
		assert_equal( 0, @rect.nbits )
	end

	def test_default_frame_nbits
		val = 0b01111000
		@rect.nbits = val
		assert_equal( 15, @rect.nbits )
	end

	def test_default_frame
		raw_bytes = [ 0x78, 0x00, 0x06, 0xD6, 0x00, 0x00, 0x13, 0x88, 0x00 ]
		string_bytes = raw_bytes.pack( "c*" )

		@rect.nbits = string_bytes[0]
		assert_equal( 15, @rect.nbits )

		@rect.bytes = string_bytes

		assert_equal( 0, @rect.min_x )
		assert_equal( 0, @rect.min_y )

		assert_equal( 700*20, @rect.max_x )
		assert_equal( 500*20, @rect.max_y )
	end
end
