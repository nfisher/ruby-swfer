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
	def big_ui32
		read_bytes(DWORD,'N')
	end


	# Decodes a 16-bit unsigned integer in big endian format.
	#
	def big_ui16
		read_bytes(WORD,'n')
	end
	

	# Decodes a 64-bit unsigned integer in little endian format.
	#
	def little_ui64
	end


	# Decodes a 32-bit unsigned integer in little endian format.
	#
	def little_ui32
		read_bytes(DWORD,'V')
	end


	# Decodes a 16-bit unsigned integer in little endian format.
	#
	def little_ui16
		read_bytes(WORD,'v')
	end


	# Decodes a single unsigned byte.
	#
	def ui8
		read_bytes(BYTE,'C')
	end


	# Retrieves a string the length specified.
	#
	def gets( len )
		@file.read( len )
	end

	private
	def read_bytes( count, type )
		tmp = @file.read( count )
		tmp.unpack( type ).shift
	end
end


