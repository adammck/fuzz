#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Height < Base
		# this should be merged with the Length
		# token, by wrapping and patching the pattern
		Pattern = '(?:(?:height of|height:?|standing)\s*)?(\d+)(?:\s*(?:centimeters?|cm))?(?:\s*(?:tall))?'
		
		# convert captured digits
		# into a fixnum object
		def normalize(height_str)
			height_str.to_i
		end
	end
end
