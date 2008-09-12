#!/opt/local/bin/ruby -w

require 'swfreader'


# Outputs the usage of this script
#
def usage
	puts "Usage: #{$0} FILE"
	exit
end


COLUMN_DELIMITER = "%15s = %s\n"


# Executes the main program loop
#
def main
	usage if ARGV.empty?

	filename = ARGV[0]

	reader = SwfReader.new( filename )
	header = reader.read_header

	puts ""
	puts "============ Header Details ============"
	printf( COLUMN_DELIMITER, "File", filename )
	printf( COLUMN_DELIMITER, "Length", header.length )
	printf( COLUMN_DELIMITER, "Compression", header.compressed? )
	printf( COLUMN_DELIMITER, "Version", header.version )
	printf( COLUMN_DELIMITER, "Frame Rate", header.frame_rate )
	printf( COLUMN_DELIMITER, "Frame Count", header.frame_count )
	printf( COLUMN_DELIMITER, "Frame X", header.frame_size.min_x / 20 )
	printf( COLUMN_DELIMITER, "Frame Y", header.frame_size.min_y / 20 )
	printf( COLUMN_DELIMITER, "Frame Width", header.frame_size.max_x / 20 )
	printf( COLUMN_DELIMITER, "Frame Height", header.frame_size.max_y / 20 )
	puts "========================================"
	puts ""
end

main
