#!/usr/bin/env ruby
# vim: noet

module Fuzz
	module Error
		
		class FuzzError < StandardError
		end
		
		# Raised by Fuzz::Parser when results
		# are accessed before they have been
		# built (by calling Fuzz::Parser#parse)
		class NotParsedYet < FuzzError
		end
	end
end
