class SwfRect
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

	def bytes=( bytes )
		@bytes = 0
		bytes.each_byte do |ch|
			@bytes |= ch
			@bytes = @bytes << 8
		end

		@min_x = at( 0 )
		puts "min x: #{@min_x}"

		@max_x = at( 1 )
		puts "max x: #{@max_x}"

		@min_y = at( 2 )
		puts "min y: #{@min_y}"

		@max_y = at( 3 )
		puts "max y: #{@max_y}"
	end

	private
	def at( i )
		value = 0
		first =	5 + (i * @nbits) 
		last = first + @nbits - 1

		(first..last).each do |i|
			value |= @bytes
			value = value << 1 unless i == last
		end

		value
	end
end


