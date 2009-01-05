#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Gender < Base
		Male   = ["male", "man", "boy", "m"]
		Female = ["female", "woman", "girl", "f"]
		Pattern = (Male + Female).join("|")

		# whatever variation of gender was
		# matched, return a regular symbol
		def normalize(gender_str)
			Male.include?(gender_str) ? (:male) : (:female)
		end
		
		Examples = {
			"male"   => :male,
			"female" => :female,
			"boy"    => :male,
			"girl"   => :female }
	end
end
