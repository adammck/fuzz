#!/usr/bin/env ruby
# vim: noet

require "rubygems"
require "chronic"


module Fuzz::Token
	class Age < Base
		
		Prefix = '(?:aged?\s*)?'
		Meat   = '(\d+)'
		Suffix = '(?:\s*(years? old|years?|yrs?|y/?o|months? old|months|m/o|days? old|days|d/o))?'
		
		# create one big ugly regex
		Pattern = Prefix + Meat + Suffix
		
		# set reasonable boundaries as
		# default, which can be overridden
		# at initialization
		Options = {
			:min => 0,
			:max => 3122064000,
			:humanize_unit => :year,
			:default_unit => :year
		}
		
		def accept?(fm)
			dob = fm.value
			return false if dob.nil?
			age_in_seconds = Time.now - dob
			(age_in_seconds >= @options[:min]) && (age_in_seconds <= @options[:max])
		end
		
		# convert the long numeric
		# capture into an integer
		def normalize(age_str, unit_str=nil)
			
			# resolve the unit string to
			# a regular string that we
			# can pass to chronic
			first = unit_str.to_s[0,1]
			if    first == "":  unit = @options[:default_unit]
			elsif first == "y": unit = "year"
			elsif first == "m": unit = "month"
			elsif first == "d": unit = "day"
			end
			
			# pass a nice string like "2 years ago" to chronic,
			# so it will return a Time containing all
			# of the days that the DOB could have been
			begin
				Chronic.parse("#{age_str} #{unit}s ago")
			
			# something went wrong (it's not really important
			# what), so return nil, to be caught by the _accept?_
			# method, which will cancel the match
			rescue StandardError
				nil
			end
		end
		
		
		SECONDS_IN = {
			:day   => 86400,
			:month => 2629743,
			:year  => 31556926
		}
		
		# display the date according to the prefered
		# format of this field, which is not necessarily
		# the format the it was entered in. kind of ugly
		def humanize(dob)
			unit = @options[:humanize_unit]
			val = (((Time.now - dob) / SECONDS_IN[unit]).floor)
			suffix = (val == 1) ? "" : "s"
			"#{val} #{unit}#{suffix} old"
		end
		
		# various ways of specifying someones age
		Examples = {
			"1"             => 1,
			"2 year"        => 2,
			"3 years"       => 3,
			"4 years old"   => 4,
			"age 5"         => 5,
			"aged 6 years"  => 6,
			"999 years old" => 999 }
	end
end
