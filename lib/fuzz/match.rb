#!/usr/bin/env ruby
# vim: noet

module Fuzz
	class Match
		attr_reader :match_data, :captures, :delimiters
		
		def initialize(md)
			@match_data = md
			cap = md.captures
			
			# Break the captures from the delimiters
			# (the first and last) and token (others)
			# into their own accessors. Most of the
			# time, we're not interested capturing
			# the delimiters, and this slicing the
			# array every single time
			@delimiters = [cap.shift, cap.pop]
			@captures = cap
		end
		
		def [](index)
			@captures[index]
		end
	end
end
