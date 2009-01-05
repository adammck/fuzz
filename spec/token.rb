#!/usr/bin/env ruby
# vim: noet


# import rspec
require "rubygems"
require "spec"

# import the fuzz gem for testing
dir = File.dirname(__FILE__)
require "#{dir}/../lib/fuzz.rb"


class AbcToken < Fuzz::Token::Base
	Pattern = '[abc]+'
end


describe Fuzz::Token::Base do
	it "refuses to initialize base" do
		lambda { Fuzz::Token::Base.new }.should raise_error
	end

	it "allows instances of subclasses" do
		lambda { AbcToken.new }.should_not raise_error
	end
	
	#it "lists defined types" do
	#	AbcToken.defined_types
	#end
	
	it "creates a safe symbol name from its title" do
		AbcToken.new("Blah Blah").name.should == :blah_blah
		AbcToken.new("This is a ^Token^ Name!").name.should == :this_is_a_token_name
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
		
		it "returns nil when no match is found" do
			@abc.extract("INVALID").should == nil
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
			
			ext1[0].value.should == "a"
			ext2[0].value.should == "b"
			ext3[0].value.should == "c"
		end
	end
	
	
	describe "(extract!)" do
		before(:each) do
			@abc = AbcToken.new
		end
		
		it "modifies the argument" do
			str = "xxx a yyy b zzz c yyy"
			@abc.extract!(str).value.should == "a"
			@abc.extract!(str).value.should == "b"
			@abc.extract!(str).value.should == "c"
		end
	end
end


# iterate all of the subclasses of F:T:B
base = Fuzz::Token::Base
ObjectSpace.each_object(Class) do |klass|
	if klass.ancestors.include?(base) and klass != base

		# automate the initial specification
		# for predefined Token subclasses
		describe klass do
			if klass.const_defined?(:Examples)
			
				# convert each Example in the class into
				# a test, to keep the examples alongside
				# the regexen in the source
				klass.const_get(:Examples).each do |str, parsed|
					it "accepts Example: #{str}" do
						token = klass.new
						ex = token.extract(str)
						ex.should_not == nil
			
						# the output should be correct, and
						# there should be nothing left over
						ex[0].value.should == parsed
						ex[1].should == ""
					end
				end# each
				
			end
		end# describe
		
	end
end# each_object
