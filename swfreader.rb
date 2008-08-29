require 'gulliversextractor'
require 'swfheader'
require 'swfrect'

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


