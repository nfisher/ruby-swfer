class GulliversExtractor
	BYTE = 1
	WORD = 2
	DWORD = 4
	QWORD = 8

	def initialize( file )
		@file = file
	end

	# Decodes a 64-bit unsigned integer in big endian format.
	#
	def big_ui64
	end


	# Decodes a 32-bit unsigned integer in big endian format.
	#
	def big_ui32( tmp = nil )
		read_bytes(DWORD,'N',tmp)
	end


	# Decodes a 16-bit unsigned integer in big endian format.
	#
	def big_ui16( tmp = nil )
		read_bytes(WORD,'n',tmp)
	end
	

	# Decodes a 64-bit unsigned integer in little endian format.
	#
	def little_ui64
	end


	# Decodes a 32-bit unsigned integer in little endian format.
	#
	def little_ui32( tmp = nil )
		read_bytes(DWORD,'V',tmp)
	end


	# Decodes a 16-bit unsigned integer in little endian format.
	#
	def little_ui16( tmp = nil )
		read_bytes(WORD,'v',tmp)
	end


	# Decodes a single unsigned byte.
	#
	def ui8( tmp = nil )
		read_bytes(BYTE,'C',tmp)
	end


	# Retrieves a string the length specified.
	#
	def gets( len )
		@file.read( len )
	end

	private
	def read_bytes( count, type, tmp = nil )
		tmp = @file.read( count ) if tmp.nil?
		tmp.unpack( type ).shift
	end
end


