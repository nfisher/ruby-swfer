lib = File.dirname(__FILE__)

files = %w[gulliversextractor swfheader swfrect]
files.each { |f| require lib + "/#{f}.rb" }
