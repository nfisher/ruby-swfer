class SwfHeader
	attr :length, true
	attr :version, true
	attr :frame_size, true
	attr :frame_rate, true
	attr :frame_count, true

	SIGNATURE = 'WS'
	COMPRESSION = 'C'
	NOCOMPRESSION = 'F'
	FRAME_OFFSET = 8

	def initialize
		@compressed = nil
	end

	# Throws an error if the signature is not valid for a SWF file up to Version 9.
	#
	def signature=( new_signature )
		throw ArgumentError.new( "Invalid file signature." ) if( new_signature != SIGNATURE )
	end


	def compressed=( compressed )
		if( compressed == COMPRESSION )
			@compressed = true
		elsif( compressed == NOCOMPRESSION )
			@compressed = false
		else
			throw ArgumentError.new( "Incorrect compression specifier." )
		end
	end

	def compressed?
		throw RuntimeError.new( "Compression unknown." ) if @compressed.nil?
		@compressed
	end
end


