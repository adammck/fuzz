#!/usr/bin/env ruby
# vim: noet


# import rspec
require "rubygems"
require "spec"

# import the fuzz gem for testing
dir = File.dirname(__FILE__)
require "#{dir}/../lib/fuzz.rb"




class AbcToken < Fuzz::Token::Base
	Pattern = "[abc]+"
end


describe Fuzz::Token::Base do
	it "refuses to initialize" do
		lambda { Fuzz::Token::Base.new }.should raise_error
	end

	it "allows instances of subclasses" do
		lambda { AbcToken.new }.should_not raise_error
	end

	it "returns nil when no match is found" do
		AbcToken.new.match("xyzzy").should == nil
	end

	it "does not match tokens with no delimiters" do
		AbcToken.new.match("12345aabbcc98765").should == nil
	end

	it "returns Fuzz::Match when a match is found" do
		m = AbcToken.new.match("12345 aabbcc 98765")
		m.class.should == Fuzz::Match
	end
	
	
	describe "(extract)" do
		before(:each) do
			@abc = AbcToken.new
		end
		
		it "returns Array of Fuzz::Match and String" do
			e = @abc.extract("zzz a yyy")
			e.class.should == Array
			e[0].class.should == Fuzz::Match
			e[1].class.should == String
		end
		
		it "returns modified String" do
			e = @abc.extract("zzz a yyy")
			e[1].should == "zzz#{Fuzz::Replacement}yyy"
		end
		
		it "extracts multiple Tokens" do
			ext1 = @abc.extract("zzz a b c yyy")
			ext2 = @abc.extract(ext1[1])
			ext3 = @abc.extract(ext2[1])
			
			ext1[0].captures[0].should == "a"
			ext2[0].captures[0].should == "b"
			ext3[0].captures[0].should == "c"
		end
	end
	
	
	describe "(extract!)" do
		before(:each) do
			@abc = AbcToken.new
		end
		
		it "modifies the argument" do
			str = "xxx a yyy b zzz c yyy"
			@abc.extract!(str)[0].should == "a"
			@abc.extract!(str)[0].should == "b"
			@abc.extract!(str)[0].should == "c"
		end
	end
end


describe Fuzz::Match do
	before(:each) do
		@m = AbcToken.new.match("qqq;;;aabbcc,,,www")
	end
	
	it "returns extracted token data" do
		@m.captures.should == ["aabbcc"]
	end

	it "returns extracted delimiters" do
		@m.delimiters.should == [";;;", ",,,"]
	end
	
	it "allows array syntax access to captures" do
		@m[0].should == "aabbcc"
	end
end
