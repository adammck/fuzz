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

# import the core classes
require "#{dir}/fuzz/token.rb"
require "#{dir}/fuzz/match.rb"
require "#{dir}/fuzz/parser.rb"
require "#{dir}/fuzz/errors.rb"

# some base token classes
require "#{dir}/fuzz/token/letters.rb"
require "#{dir}/fuzz/token/numbers.rb"

# and some common token classes
require "#{dir}/fuzz/token/gender.rb"
require "#{dir}/fuzz/token/phone.rb"
require "#{dir}/fuzz/token/age.rb"
require "#{dir}/fuzz/token/length.rb"
require "#{dir}/fuzz/token/height.rb"
require "#{dir}/fuzz/token/ratio.rb"
require "#{dir}/fuzz/token/weight.rb"

