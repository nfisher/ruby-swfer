#!/opt/local/bin/ruby -w

class SwfReader
	def initialize( filename )
		@file = File.new( filename, 'r' )
		@extractor = GulliversExtractor.new( @file )
	end

	def read_header
		header = SwfHeader.new
		header.compressed = @extractor.gets( 1 )
		header.signature = @extractor.gets( 2 )
		header.version = @extractor.ui8
		header.length = @extractor.little_ui32
		
		header.frame_size = read_rect
		header.frame_rate = @extractor.little_ui16
		header.frame_count = @extractor.little_ui16

		return header
	end

	def read_rect
		pos = @file.tell
		ub = @extractor.ui8
		@file.seek( pos, IO::SEEK_SET )

		rect = SwfRect.new
		len = rect.required_bytes( ub )
		rect.bytes = @extractor.gets( len )

		return rect
	end
end


class SwfHeader
	attr :length, true
	attr :version, true
	attr :frame_size, true
	attr :frame_rate, true
	attr :frame_count, true

	SIGNATURE = 'WS'
	COMPRESSION = 'C'
	NOCOMPRESSION = 'F'

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


class SwfRect
	attr :min_x, true
	attr :min_y, true
	attr :max_x, true
	attr :max_y, true

	def required_bytes( ub )
		ub &&= 0b11111000
		@bit_block_size = ub >> 3

		( (@bit_block_size * 4 + 5) / 8.0 ).ceil
	end


	def initialize( )
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
		tmp.unpack( type )
	end
end

def usage
	puts "Usage: #{$0} FILE"
	exit
end

def main
	usage if ARGV.empty?

	reader = SwfReader.new( ARGV[0] )
	header = reader.read_header

	$\ = "\n"
	print "Compression: ", header.compressed?
	print "Version: ", header.version
	print "Frame Rate: ", header.frame_rate
	print "Frame Count: ", header.frame_count
end

main
