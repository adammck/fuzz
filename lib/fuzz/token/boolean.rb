#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Boolean < Base
		True = ["true", "t", "yes", "y"]
		False = ["false", "f", "no", "n"]
		Pattern = (True + False).join("|")

		# whatever variation was
		# matched, return a regular symbol
		def normalize(boolean_str)
			True.include?(boolean_str) ? (:true) : (:false)
		end
		
		def humanize(boolean_str)
			boolean_str == :true ? "Y" : "N"
		end

		Examples = {
			"n"  => :false,
			"y"  => :true,
			"true"   => :true,
			"false" => :false,
			"yes"    => :true,
			"no"   => :false }
	end
end
