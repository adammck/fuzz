#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Phone < Base
		# matches a plus or zero, followed
		# by digits, dashes, and spaces
		Pattern = '([\+0][\d\s\-]+)'
		
		# strip out any useless punctuation, but
		# leave it as a string (phone numbers are
		# not just big integers)
		def normalize(phone_str)
			phone_str.gsub(/[^\d\+]/, "")
		end
		
		# various phone number formats
		# (todo: many more of these)
		Examples = {
			"09 275 342"      => "09275342",
			"09-218-581"      => "09218581",
			"+265-09 218 549" => "+26509218549" }
	end
end
