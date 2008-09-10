require 'zlib'
require 'gulliversextractor'
require 'swfheader'
require 'swfrect'

class SwfReader
	BYTE = 1
	WORD = 2
	DWORD = 4
	QWORD = 8

	def initialize( filename )
		@file = File.new( filename, 'r' )
		@extractor = GulliversExtractor.new( )
	end

	def read_header
		header = SwfHeader.new
		header.compressed = read_bytes( read_bytes(BYTE) )
		header.signature = read_bytes( read_bytes(WORD) )
		header.version = @extractor.ui8( read_bytes(BYTE) )
		header.length = @extractor.little_ui32( read_bytes(DWORD) )

		@contents = read_remaining_bytes

		# Sneaky buggers don't mention that everything after the length is
		# compressed in a CWS signatured file.
		@contents = decompress(@contents) if header.compressed?
		header.frame_size = read_rect

		throw Error if @contents.length != (header.length - SwfHeader::FRAME_OFFSET)

		return header
	end

	def read_rect
		ub = @contents[0]

		rect = SwfRect.new
		len = rect.required_bytes( ub )
		rect.bytes = @contents[0..len]

		return rect
	end

	def decompress( compressed_contents )
		zstream = Zlib::Inflate.new
		decompressed_contents = zstream.inflate( compressed_contents )
		zstream.finish
		zstream.close
		decompressed_contents
	end

	private
	def read_bytes( count )
		@file.read( count )
	end

	def read_remaining_bytes
		pos = @file.tell
		@file.seek( 0, IO::SEEK_END )
		end_pos = @file.tell
		@file.pos = pos
		read_bytes( end_pos - pos )
	end
end


