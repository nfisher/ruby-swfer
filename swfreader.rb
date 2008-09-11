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
		@contents = nil
		@pos = 0
		@on_disk_length = 0
	end

	def read_header
		header = SwfHeader.new
		header.signature =  read_bytes(SwfHeader::SIGNATURE_LENGTH)
		header.version = read_bytes(BYTE)
		header.length = @extractor.little_ui32( read_bytes(DWORD) )

		if header.compressed?
			len = @contents.size
			compressed_content = @contents.slice!( SwfHeader::FRAME_OFFSET...len )
			puts "size: #{@contents.size}"
			@contents += inflate( compressed_content )
		end


		header.frame_size = read_rect
		header.frame_rate = @extractor.little_ui16( read_bytes(WORD) )
		header.frame_count = @extractor.little_ui16( read_bytes(WORD) )

		return header
	end

	def read_rect
		ub = read_bytes(BYTE)
		rect = SwfRect.new
		rect.nbits = ub
		puts ub
		rect.bytes = read_bytes( rect.required_bytes )

		rect
	end

	def read_tag
	end

	def inflate( compressed_contents )
		zstream = Zlib::Inflate.new
		inflated_contents = zstream.inflate( compressed_contents )
		zstream.finish
		zstream.close
		inflated_contents
	end

	def pos=( new_pos )
		@pos = new_pos
	end

	def pos
		@pos
	end

	private

	def reset_pos
		pos = 0
	end

	def read_bytes( count )
		read_whole_file_and_close if @contents.nil?

		# if a byte only use the current position otherwise apply a range extraction
		range = cur = @pos
		@pos += count
		range = cur...@pos unless count == BYTE

		@contents[range]
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


