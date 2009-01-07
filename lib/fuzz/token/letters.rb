#!/usr/bin/env ruby
# vim: noet

module Fuzz::Token
	class Letters < Base
		Pattern = '[a-z]+'
		
		Examples = {
			"blah" => "blah" }
	end
end
