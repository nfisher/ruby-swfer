class SwfRect
	attr :min_x, true
	attr :min_y, true
	attr :max_x, true
	attr :max_y, true
	attr :nbits


	def initialize( )

	end


	def required_bytes( ub )
		ub &= 0b11111000
		@nbits = ub >> 3

		( (@nbits * 4 + 5) / 8.0 ).ceil
	end

	def bytes=( bytes )
		@bytes = []
		bytes.each_byte do |ch|
			@bytes << ch
		end
	end

	private
	def at( i )
		
	end
end


