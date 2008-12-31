#!/usr/bin/env ruby
# vim: noet

module Fuzz
	module Token
		class Base


			def initialize

				# this class serves no purpose
				# by itself, because it will
				# never match anything.
				if self.class == Fuzz::Token::Base
					raise RuntimeError, "Fuzz::Token cannot be " +\
					"instantiated directly. Use a subclass instead"
				end
			end

			# Returns the pattern (a string regex chunk)
			# matched by this class, or raises RuntimeError
			# if none is available.
			def pattern
				raise RuntimeError.new("#{self.class} has no pattern")\
					unless self.class.const_defined?(:Pattern)

				# ruby doesn't consider the class body of
				# subclasses to be in this scope. weird.
				self.class.const_get(:Pattern)
			end


			def match(str)
				pat = pattern

				# If the pattern contains no captures, wrap
				# it in parenthesis to captures the whole
				# thing. This is vanity, so we can omit
				# the parenthesis from the Patterns of
				# simple Token subclasses.
				pat = "(" + pat + ")"\
					unless pat.index "("

				# attempt to match this class's patten wedged
				# between delimiters, and return the MatchData
				# wrapped in Fuzz::Match or nil (no match)
				del = "(" + Fuzz::Delimiter + ")"
				m = str.match(Regexp.new(del + pat + del))
				(m == nil) ? nil : Fuzz::Match.new(m)
			end


			def extract(str)

				# attempt to match the token against _str_
				# via Base#match, and abort it it failed
				fm = match(str)
				return nil\
					if fm.nil?

				# return the Fuzz::Match and _str_ with the matched
				# token replace by Fuzz::Replacement, to continue parsing
				[fm, fm.match_data.pre_match + Fuzz::Replacement + fm.match_data.post_match]
			end


			def extract!(str)

				# call Token#extract first,
				# and abort it if failed
				ext = extract(str)
				return nil\
					if ext.nil?

				# update the argument (the BANG warns
				# of the danger of this operation...),
				# and return the Fuzz::Match
				str.replace(ext[1])
				ext[0]
			end
		end
	end
end
