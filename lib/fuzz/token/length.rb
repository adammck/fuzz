#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Length < Base
		Pattern = '(\d+)(?:\s*(?:centimeters?|cm))?'
	end
end
