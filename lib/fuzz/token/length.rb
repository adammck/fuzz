#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Length < Base
		Pattern = '(\d+)(\.\d*)?(?:\s*(?:centimeters?|cm))?'

		# convert captured digits
		# into a float object
		def normalize(length_str, decimal_str=nil)
			decimal_str.nil? ? length_str.to_f : (length_str + decimal_str).to_f
		end
		
		def humanize(length_f)
			length_f.to_s + "cm"
		end
	end
end
