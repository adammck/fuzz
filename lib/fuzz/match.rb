#!/usr/bin/env ruby
# vim: noet

$spec = "../../spec/match.rb"


module Fuzz
	class Match
		attr_reader :token, :match_data, :captures, :delimiters
		
		def initialize(token, md)
			@token = token
			@match_data = md
			cap = md.captures
			
			# insist on receiving a Token,
			# since this class doesn't do
			# anything useful without it
			raise RuntimeError\
				unless token.is_a?(Fuzz::Token::Base)
			
			# break the captures from the delimiters
			# (the first and last) and token (others)
			# into their own accessors. Most of the
			# time, we're not interested capturing
			# the delimiters, and this slicing the
			# array every single time
			@delimiters = [cap.shift, cap.pop]
			@captures = cap
		end
		
		# Returns the captures encapsulated by this
		# object after being normalized by the related
		# Token object, to transform raw captured strings
		# into useful semantic data. See: Token#normalize.
		def value
			begin
				token.normalize(*@captures)
			
			# if the normalize failed with ArgumentError, it's
			# probably because the method was expecting a different
			# number of captures, which indicates a broken regex
			rescue ArgumentError => err
				raise ArgumentError.new("Normalize failed for #{cap.inspect} via #{token.inspect}")
			end
		end
	end
end
