/*  hashfunction.c

    Wrapper around Bob Jenkins lookup3.c set of hashing functions
    http://burtleburtle.net/bob/c/lookup3.c

    Distributed under the MIT open source license

	Copyright (c) 2009 Robert Jones, Craic Computing LLC (jones@craic.com)

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
*/

#include <ruby.h>

static VALUE HashFunction;
static VALUE Lookup3;


/* Wrapper around hashlittle function - takes an arbitrary string key and an
	unsigned int intival and returns a Ruby Bignum 
	Note that the C code generates a 32-bit unsigned int - too big for a 31 bit 
	Ruby Fixnum */

static VALUE
t_hashlittle(VALUE self, VALUE key, VALUE initval)
{
    VALUE str = StringValue(key);
    VALUE val = hashlittle(RSTRING(str)->ptr, RSTRING(str)->len, NUM2UINT(initval));
	return UINT2NUM(val);
}


/*  Wrapper around hashlittle2 function - takes an arbitrary string key, a two member
    array of initvals and an array to two Ruby integers. The method returns the hash 
    values as two Bignums in this second array.

	The C code uses the same two uint ptrs for initvals and hashvalues - but this requires
	that you actively reset the initvals every time you call the function, otherwise
	the hash values depend on the last key given to the function. To avoid this issue,
	the Ruby wrapper takes two initvals in a separate array and uses these every time.

	Note that the array is assumed to have two elements in it
	
	Note that the C code generates a 32-bit unsigned int - too big for a 31 bit 
	Ruby Fixnum, hence it is returned as a Ruby Bignum
	TODO - figure out some way to avoid this - return the hash value as a 4 byte string?
*/

static VALUE
t_hashlittle2(VALUE self, VALUE key, VALUE initvals, VALUE hashvalues)
{
    VALUE str = StringValue(key);

	unsigned int h0 = NUM2UINT(RARRAY(initvals)->ptr[0]);
	unsigned int h1 = NUM2UINT(RARRAY(initvals)->ptr[1]);

    hashlittle2(RSTRING(str)->ptr, RSTRING(str)->len, &h0, &h1);

	RARRAY(hashvalues)->ptr[0] = UINT2NUM(h0);
	RARRAY(hashvalues)->ptr[1] = UINT2NUM(h1);
    return Qnil;
}


/* Set up the correspondence between the Ruby and C functions */ 
void
Init_hashfunction(void)
{
	HashFunction = rb_define_module("HashFunction");
    Lookup3 = rb_define_class_under(HashFunction, "Lookup3", rb_cObject);

    rb_define_method(Lookup3, "hashlittle",  t_hashlittle,  2);
    rb_define_method(Lookup3, "hashlittle2", t_hashlittle2, 3);
}


