#:_____________________________________________________
#  nmath  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:_____________________________________________________
# Module dependencies
import ./random

proc oneIn *(r :SomeInteger) :bool=  rnd(r) == 0

