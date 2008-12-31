#!/usr/bin/env ruby
# vim: noet

module Fuzz

	# The character inserted in place of a Token
	# when it is plucked out of a string (to prevent
	# the surrounding text from beind considered a
	# single token, when it is clearly not)
	Replacement = 0.chr

	# The regex chunk which is considered a valid
	# delimiter between tokens in a form submission.
	Delimiter = '\A|[\s;,]+|' + Replacement + '|\Z'

end

dir = File.dirname(__FILE__)
require "#{dir}/fuzz/token.rb"
require "#{dir}/fuzz/match.rb"
