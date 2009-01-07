#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Weight < Base
		
		Prefix = '(?:weighing?\s*)?'
		Meat   = '(\d+)'
		Suffix = '(?:\s*(?:kilogram?|kilogrammes?|kg))?'
		
		# create one big ugly regex
		Pattern = Prefix + Meat + Suffix
		
		# convert captured digits
		# into a fixnum object
		def normalize(weight_str)
			weight_str.to_i
		end
	end
end
