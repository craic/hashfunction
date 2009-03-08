# test_hashfunction.rb

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'hashfunction'
require 'test/unit'


class Lookup3Test < Test::Unit::TestCase
  
  # Implementation of the driver5 tests in lookup3.c
  def setup()
    @h = HashFunction::Lookup3.new
  end
  
  def test_driver5_1
    hashvals = Array.new(2)
    initvals = [0, 0]
    key = ''
    @h.hashlittle2(key, initvals, hashvals)
    str0 = sprintf "%.8x", hashvals[0]
    str1 = sprintf "%.8x", hashvals[1]
    assert_equal str0, 'deadbeef'
    assert_equal str1, 'deadbeef'
  end

  def test_driver5_2
    hashvals = Array.new(2)
    initvals = [0, 0xdeadbeef]
    key = ''
    @h.hashlittle2(key, initvals, hashvals)
    str0 = sprintf "%.8x", hashvals[0]
    str1 = sprintf "%.8x", hashvals[1]
    assert_equal str0, 'bd5b7dde'
    assert_equal str1, 'deadbeef'
  end

  def test_driver5_3
    hashvals = Array.new(2)
    initvals = [0xdeadbeef, 0xdeadbeef]
    key = ''
    @h.hashlittle2(key, initvals, hashvals)
    str0 = sprintf "%.8x", hashvals[0]
    str1 = sprintf "%.8x", hashvals[1]
    assert_equal str0, '9c093ccd'
    assert_equal str1, 'bd5b7dde'
  end

  def test_driver5_4
    hashvals = Array.new(2)
    initvals = [0, 0]
    key = 'Four score and seven years ago'
    @h.hashlittle2(key, initvals, hashvals)
    str0 = sprintf "%.8x", hashvals[0]
    str1 = sprintf "%.8x", hashvals[1]
    assert_equal str0, '17770551'
    assert_equal str1, 'ce7226e6'
  end

  def test_driver5_5
    hashvals = Array.new(2)
    initvals = [0, 1]
    key = 'Four score and seven years ago'
    @h.hashlittle2(key, initvals, hashvals)
    str0 = sprintf "%.8x", hashvals[0]
    str1 = sprintf "%.8x", hashvals[1]
    assert_equal str0, 'e3607cae'
    assert_equal str1, 'bd371de4'
  end

  def test_driver5_6
    hashvals = Array.new(2)
    initvals = [1, 0]
    key = 'Four score and seven years ago'
    @h.hashlittle2(key, initvals, hashvals)
    str0 = sprintf "%.8x", hashvals[0]
    str1 = sprintf "%.8x", hashvals[1]
    assert_equal str0, 'cd628161'
    assert_equal str1, '6cbea4b3'
  end

  # Test of the hashlittle function
  def test_driver5_7
    initval = 0
    key = 'Four score and seven years ago'
    hashval = @h.hashlittle(key, initval)
    str = sprintf "%.8x", hashval
    assert_equal str, '17770551'
  end

  # Test of the hashlittle function
  def test_driver5_8
    initval = 1
    key = 'Four score and seven years ago'
    hashval = @h.hashlittle(key, initval)
    str = sprintf "%.8x", hashval
    assert_equal str, 'cd628161'
  end

end
