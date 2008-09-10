class SwfRect
	NBITS_FIELD_LENGTH = 5
	BYTE_SIZE = 8
	attr :min_x, true
	attr :min_y, true
	attr :max_x, true
	attr :max_y, true

	def initialize
		@nbits = nil
	end

	def required_bytes
		return nil if @nbits.nil?	

		@required_bytes = ( (@nbits * 4 + 5) / 8.0 ).ceil
	end

	def nbits
		@nbits
	end

	def nbits=( byte )
		ub = byte
		ub &= 0b11111000
		@nbits = ub >> 3
	end


	#
	# bytes=: extracts the min and max for x and y.
	#
	def bytes=( bytes )
		@bytes = 0

		bits = bytes.unpack( "B*" ).shift

		bits.each_byte do |bit|
			@bytes |= 1 if bit == 49
			@bytes << 1
		end
		puts @bytes

		@min_x = at( 0 )
		puts "min x: #{@min_x}"

		@max_x = at( 1 )
		puts "max x: #{@max_x/20}"

		@min_y = at( 2 )
		puts "min y: #{@min_y}"

		@max_y = at( 3 )
		puts "max y: #{@max_y/20}"
	end

	private
	def at( i )
		value = 0
		# Bignum appears to buffer on 4 byte boundaries so 9 bytes is padded with
		# zeros to 12 bytes
		initial_offset = (@bytes.size - required_bytes) * BYTE_SIZE + NBITS_FIELD_LENGTH
		first =	initial_offset + ( i * @nbits ) 
		last = first + @nbits

		sign_bit = @bytes[first]

		(first...last).each do |i|
			value |= @bytes[i]
			value = value << 1
		end

		value *= -1 if sign_bit == 1

		value
	end
end


