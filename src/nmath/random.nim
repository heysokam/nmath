#:_________________________________________________________
#  nmath  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT      :
#  This file contains modified code from ftsf/nico (MIT)  :
#  See the license.md for details about its copyright.    :
#:_________________________________________________________
# ndk dependencies
import std/random

#______________________________
# Seeds
proc srand *(seed :SomeInteger) :void=
  ## Sets the seed for random number operations
  if seed == 0: raise newException(Exception, "Do not srand(0)")
  randomize(seed)
proc srand *() :void=  randomize()
  ## Sets the seed for random number operations to a random seed

#______________________________
# Number gen
proc rnd *[T :Natural](x :T) :T=  return rand(x.int-1).T
  ## Returns a random number from 0..<x, x will never be returned
proc rnd *[T :SomeFloat](x :T) :SomeFloat=  return rand(x)
  ## Returns a random float from 0..x
proc rnd *[T](min, max :T) :T=  return rand(max - min) + min
  ## Returns a random number from min..max inclusive
proc rnd *[T](a :openarray[T]) :T=  return sample(a)
  ## Returns a random element of a
proc rnd *[T](x :HSlice[T,T]) :T=  return rand(x)
  ## Returns a random element in slice
proc rndbi *[T](x :T) :T=  return rand(x) - rand(x)
  ## Returns a random number between -x..x inclusive

