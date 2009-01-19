#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Weight < Base
		
		Prefix = '(?:weighing?\s*)?'
		Meat   = '(\d+)(\.\d*)?'
		Suffix = '(?:\s*(?:kilogram?|kilogrammes?|kg))?'
		
		# create one big ugly regex
		Pattern = Prefix + Meat + Suffix
		
		# convert captured digits
		# into a float object
		def normalize(weight_str, decimal_str=nil)
			decimal_str.nil? ? weight_str.to_f : (weight_str + decimal_str).to_f
		end

		def humanize(weight_f)
			weight_f.to_s + "kg"
		end
	end
end
