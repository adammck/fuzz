#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Number < Base
		Pattern = '\d+'
		
		# convert captured digits
		# into a fixnum object
		def normalize(digits_str)
			digits_str.to_i
		end
		
		Examples = {
			"123" => 123 }
	end
end
