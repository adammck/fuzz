#!/usr/bin/env ruby
# vim: noet

$spec = "../../spec/parser.rb"


module Fuzz
	class Parser
		attr_reader :tokens

		def initialize
			@tokens = []
			@matches = nil
		end

		def add_token(title, token, *init_args)

			# resolve symbolic types into
			# a predefined token class
			token = Fuzz::Token.const_get(camelize(token))\
				if token.is_a?(Symbol)

			# resolve classes into
			# instances if necessary
			token = token.new(title, *init_args)\
				if token.is_a?(Class)

			@tokens.push(token)
		end

		def parse(str)
			@matches = []
			summary = {}
			
			@tokens.each do |token|
				unless(extracted = token.extract!(str)).nil?
					summary[token.name] = extracted.value
					@matches.push(extracted)
				end
			end
			
			# store the remains of the input, in
			# case we want to do something useful
			# with it (like refer it to a human)
			@unparsed_str = str

			# return nil for no matches, or hash
			# containing a summary of the matches
			(summary.length == 0) ? nil : summary
		end
		
		# Returns an array of the tokens matched
		# by the parser, or raises NotParsedYet
		# if _parse_ has not been called yet.
		def matches
			raise_unless_parsed
			@matches
		end
		
		# Returns an Array containing the parts
		# of the parsed string that were not captured
		# and normalized into useful data by _parse_.
		#
		#   p = Fuzz::Parser.new
		#   p.add_token "age", :age
		#
		#   p.parse("13 year old")
		#   p.unparsed => []
		#
		#   p.parse("13 blah blah")
		#   p.unparsed => ["blah blah"]
		#
		#   p.parse("blah 13 y/o blah")
		#   p.unparsed => ["blah", "blah"]
		#
		def unparsed
			raise_unless_parsed
			@unparsed_str.split(Fuzz::Replacement)
		end
		
		# Returns the match of the parsed token of
		# the name _token_name_, or nil if no such
		# token exists. Raises NotParsedYet if no
		# string has been parsed yet.
		def [](token_name)
			raise_unless_parsed
			@matches.each do |mat|
				if mat.token.name == token_name
					return mat
				end
			end
			
			# no token returned
			# yet = NO TOKEN FOUND
			nil
		end

		private

		def camelize(sym)
			sym.to_s.gsub(/(?:\A|_)(.)/) { $1.upcase }
		end
		
		# Raised NotParsedYet unless @matches
		# has been populated by _parse_, to
		# be called by methods that don't make
		# sense until something has been parsed.
		def raise_unless_parsed
			raise Fuzz::Error::NotParsedYet\
				if @matches.nil?
		end
	end
end
