#!/usr/bin/env ruby

# hashfunction_example.rb

# Copyright 2009  Robert Jones, Craic Computing LLC  jones@craic.com
# Distributed under the MIT open source license

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'hashfunction'

h = HashFunction::Lookup3.new
keys = ['hello', 'world', 'foo', 'bar']

print "Example with hashlittle returning 1 hash value per function call\n"

keys.each do |key|
  printf "hashlittle   key  %-10s   val  %10d\n", key, h.hashlittle(key, 0)
end

print "\nExample with hashlittle2 returning 2 hash values per function call\n"

initvals = [0, 0]
array = Array.new(2, 0)
keys.each do |key|
  h.hashlittle2(key, initvals, array)
  printf "hashlittle2 key  %-10s   val  %10d  %10d\n", key, array[0], array[1]
end


# Code to generate multiple hashes - Enhanced Double Hashing technique of
#
# Dillinger, Peter C.; Manolios, Panagiotis (2004b), "Bloom Filters in Probabilistic Verification", 
# Proceedings of the 5th Internation Conference on Formal Methods in Computer-Aided Design, 
# Springer-Verlag, Lecture Notes in Computer Science 3312
#
# http://www.cc.gatech.edu/fac/Pete.Manolios/research/bloom-filters-verification.html

print "\nExample with hashlittle2 and Enhanced Double Hashing\n"
array = Array.new(6, 0)
initvals = [0, 0]
key = 'hello world'
h.hashlittle2(key, initvals, array)

h0 = array[0]
h1 = array[1]
printf "hashlittle2 EDH  %2d  val  %10d\n", 1, h0
printf "hashlittle2 EDH  %2d  val  %10d\n", 2, h1

n = 2**32
1.upto(10) do |i|
  h0 = (h0 + h1) % n
  h1 = (h1 + 1)  % n
  printf "hashlittle2 EDH  %2d  val  %10d\n", i+2, h0
end




