require 'zlib'
require 'gulliversextractor'
require 'swfheader'
require 'swfrect'

class SwfReader
	BYTE = 1
	WORD = 2
	DWORD = 4
	QWORD = 8
	SIGNATURE_LENGTH = 3

	def initialize( filename )
		@file = File.new( filename, 'r' )
		@extractor = GulliversExtractor.new( )
		@contents = nil
		@pos = 0
		@on_disk_length = 0
	end

	def read_header
		header = SwfHeader.new
		header.signature =  read_bytes(SIGNATURE_LENGTH)
		header.version = @extractor.ui8( read_bytes(BYTE) )
		header.length = @extractor.little_ui32( read_bytes(DWORD) )

		# Sneaky buggers don't mention that everything after the length is
		# compressed in a CWS signatured file.
		len = @contents.size
		@contents = decompress(@contents[QWORD...len]) if header.compressed?

		header.frame_size = read_rect
		header.frame_rate = @extractor.little_ui16( read_bytes(WORD) )
		header.frame_count = @extractor.little_ui16( read_bytes(WORD) )

		throw Error if @contents.length != (header.length - SwfHeader::FRAME_OFFSET)

		return header
	end

	def read_rect
		ub = @contents[0]

		rect = SwfRect.new
		rect.nbits = ub
		len = rect.required_bytes
		rect.bytes = @contents[0...len]

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
		read_whole_file_and_close if @contents.nil?

		cur = @pos
		@pos += count

		@contents[cur...@pos]
	end

	def read_whole_file_and_close
		pos = @file.tell
		@file.seek( 0, IO::SEEK_END )
		end_pos = @file.tell
		@file.pos = pos
		@on_disk_length = end_pos - pos
		@contents = @file.read( @on_disk_length )
		@file.close
	end
end


