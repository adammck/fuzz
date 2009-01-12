#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Height < Base
		# this should be merged with the Length
		# token, by wrapping and patching the pattern
		Pattern = '(?:(?:height of|height:?|standing)\s*)?(\d+)(\.\d+)?(?:\s*(?:centimeters?|cm))?(?:\s*(?:tall))?'
		
		# convert captured digits
		# into a float object
		def normalize(height_str, decimal_str=nil)
			decimal_str.nil? ? height_str.to_f : (height_str + decimal_str).to_f
		end

		def humanize(height_f)
			height_f.to_s + "cm"
		end
	end
end
