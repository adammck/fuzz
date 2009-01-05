#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Age < Base
		
		Prefix = '(?:aged?\s*)?'
		Meat   = '(\d+)'
		Suffix = '(?:\s*(?:years? old|years?|yrs?|y/?o))?'
		
		# create one big ugly regex
		Pattern = Prefix + Meat + Suffix
		
		# set reasonable boundaries as
		# default, which can be overridden
		# at initialization
		Options = {
			:min => 1,
			:max => 99
		}
		
		# convert the long numeric
		# capture into an integer
		def normalize(age_str)
			age_str.to_i
		end
		
		# various ways of specifying someones age
		Examples = {
			"1"             => 1,
			"2 year"        => 2,
			"3 years"       => 3,
			"4 years old"   => 4,
			"age 5"         => 5,
			"aged 6 years"  => 6,
			"999 years old" => 999 }
	end
end
