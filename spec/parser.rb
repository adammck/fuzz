#!/usr/bin/env ruby
# vim: noet


# import rspec
require "rubygems"
require "spec"

# import the fuzz gem for testing
dir = File.dirname(__FILE__)
require "#{dir}/../lib/fuzz.rb"


describe Fuzz::Token::Base do
	before(:each) do
		@p = Fuzz::Parser.new
		@p.add_token "Age", :age
		@p.add_token "Gender", :gender
	end
	
	it "raises NotParsedYet if matches are access before parsing" do
		lambda { @p.matches }.should raise_error Fuzz::Error::NotParsedYet
	end
	
	it "rejects an invalid string" do
		@p.parse("THIS IS INVALID").should == nil
	end
	
	
	# all of the following strings should
	# be parsed into age:2 and gender:male,
	[	"2 year old boy",
		"boy of 2 years old",
		"male, 2 years old",
		"2 male",
		"male female male 2"
	
	# generate a spec from each example
	].each do |str|
		it "parses example: #{str}" do
			@p.parse(str).should == {:age=>2, :gender=>:male}
		end
	end
	
	
	it "returns the unparsed parts of partially-valid input" do
		
		# nothing left by parsing
		@p.parse("13 year old")
		@p.unparsed.should == []
		
		# trailing junk data
		@p.parse("14 alpha bravo")
		@p.unparsed.should == ["alpha bravo"]
		
		# leading junk data
		@p.parse("charlie 15 yrs")
		@p.unparsed.should == ["charlie"]
		
		# wrapped in junk data
		@p.parse("delta 16 echo")
		@p.unparsed.should == ["delta", "echo"]
		
		# multiple junk chunks between valid data
		@p.parse("another 15 year old black-haired boy with measles")
		@p.unparsed.should == ["another", "black-haired", "with measles"]
	end
end
