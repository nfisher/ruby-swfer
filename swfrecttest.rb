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
		val = 0b01111000000000000000011111010000000000000000000000011111010000000
		last = val.size * 8
		# @rect.nbits = val[0]
		# assert_equal( 15, @rect.nbits )
	end
end
