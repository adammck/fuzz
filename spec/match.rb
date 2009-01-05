#!/usr/bin/env ruby
# vim: noet


# import rspec
require "rubygems"
require "spec"

# import the fuzz gem for testing
dir = File.dirname(__FILE__)
require "#{dir}/../lib/fuzz.rb"



describe Fuzz::Match do
	before(:each) do
	
		# create a temporary token
		# that matches any digits
		@token = Class.new(Fuzz::Token::Base)
		@token.const_set :Pattern, '\d+'
		@inst = @token.new
		
		# test a single Fuzz::Match object returned by
		# Token#match. this means that we're relying on
		# the spec/token.rb tests passing
		@match = @inst.match("alpha beta, 123; gamma 456 -- epsilon")
	end
	
	it "stores the related token" do
		@match.token.should == @inst
	end
	
	it "returns normalized token value" do
	  @match.value.should == "123"
	end
	
	it "returns raw token captures" do
		@match.captures.should == ["123"]
	end

	it "returns extracted delimiters" do
		@match.delimiters.should == [", ", "; "]
	end
end
