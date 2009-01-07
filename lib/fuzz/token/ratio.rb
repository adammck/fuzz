#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Ratio < Base
		Pattern = '((?:0\.)?\d{1,3})%?'
		
		# convert captured digits
		# into a float object
		def normalize(ratio_str)
			r = ratio_str.to_f
			(r > 1) ? r/100 : r
		end
		
		Examples = {
			"75"   => 0.75,
			"50%"  => 0.5,
			"0.25" => 0.25 }
	end
end
