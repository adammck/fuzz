#!/usr/bin/env ruby
# vim: noet

$spec = "../../spec/token.rb"


module Fuzz
	module Token
		class Base

			def self.defined_types
				subclasses = []
				base = Fuzz::Token::Base
				ObjectSpace.each_object(Class) do |klass|
					if klass.ancestors.include?(base) and klass != base
						subclasses.push(klass)
					end
				end
			end
			
			
			attr_reader :title, :options
			
			def initialize(title=nil, options={})
				@title = title
				
				# if this token class has predefined
				# options, then store them overridden
				# by the given options
				if self.class.const_defined?(:Options)
					@options = self.class.const_get(:Options).merge(options)
				
				# otherwise, just store the
				# options as they were given
				else
					@options = options
				end

				# this class serves no purpose
				# by itself, because it will
				# never match anything.
				if self.class == Fuzz::Token::Base
					raise RuntimeError, "Fuzz::Token cannot be " +\
					"instantiated directly. Use a subclass instead"
				end
			end
			
			# Returns an identifier for this token based upon
			# the name, which is safe to use as a Hash key, by
			# stripping non-alphanumerics and converting spaces
			# to underscores. (Technically, any string (or Object)
			# is safe to use as a Hash key, but it's ugly, and
			# this is not.)
			# 
			#   SampleToken.new("Age of Child").name => :age_of_child
			#   SampleToken.new("It's a Weird Token Name!").name => :its_a_weird_token_name
			#
			def name
				title.downcase.gsub(/\s+/, "_").gsub(/[^a-z0-9_]/i, "").to_sym
			end


			# Returns the pattern (a Regex) matched by this
			# class, or raises RuntimeError if none is available.
			def pattern
				raise RuntimeError.new("#{self.class} has no pattern")\
					unless self.class.const_defined?(:Pattern)

				# ruby doesn't consider the class body of
				# subclasses to be in this scope. weird.
				pat = self.class.const_get(:Pattern)

				# If the pattern contains no captures, wrap
				# it in parenthesis to captures the whole
				# thing. This is vanity, so we can omit
				# the parenthesis from the Patterns of
				# simple Token subclasses.
				pat = "(" + pat + ")"\
					unless pat.index "("

				# return the patten wedged between delimiters,
				# to avoid matching within other token bodies
				del = "(" + Fuzz::Delimiter + ")"
				Regexp.new(del + pat + del)
			end


			def match(str)
				
				# perform the initial match by comparing
				# the string with this classes regex, and
				# abort if nothing matches
				md = str.match(pattern)
				return nil if md.nil?
				
				# wrap the return value in Fuzz::Match, to
				# provide much more useful access than the
				# raw MatchData from the regex
				Fuzz::Match.new(self, md)
			end
			
			
			# Returns the "normalized" result of the given
			# strings captured by this class's Pattern by
			# the _match_ method, excluding delimiters.
			# 
			# This method provides a boring default behavior,
			# which is to return nil for no captures, String
			# for a single capture, or Array for multiple.
			# Most subclasses should overload this, to return a
			# more semantic value (like a DateTime, Weight, etc)
			#
			#   t = SampleToken.new("My Token")
			#   t.normalize("beta", "gamma") => ["beta", "gamma"]
			#   t.normalize("alpha") => "alpha"
			#   t.normalize => nil
			#
			def normalize(*captures)
				if captures.length == 0
					return nil
				
				elsif captures.length == 1
					return captures[0]
				
				# default: return as-is, and leave for
				# the receiver to deal with. tokens doing
				# this should probably overload this method.
				else; return captures; end
			end


			def extract(str)

				# attempt to match the token against _str_
				# via Base#match, and abort it it failed
				fm = match(str)
				return nil if fm.nil?
				m = fm.match_data

				# return the Fuzz::Match and _str_ with the matched
				# token replace by Fuzz::Replacement, to continue parsing
				join = ((!m.pre_match.empty? && !m.post_match.empty?) ? Fuzz::Replacement : "")
				[fm, m.pre_match + join + m.post_match]
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
