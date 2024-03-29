#:_________________________________________________________
#  nmath  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT      :
#  This file contains modified code from ftsf/nico (MIT)  :
#  See the license.md for details about its copyright.    :
#:_________________________________________________________
# std dependencies
from std/math import sqrt

#______________________________
# Float specific tools
# For controlling FP errors and approximations.
#______________________________

#______________________________
const Phi     *:SomeFloat= (1 + 5'f64.sqrt) / 2  ## Golden Ratio, Phi = (1 + 5.sqrt) / 2
const Epsilon *:SomeFloat= 0.00001

#______________________________
func appr*(val, target, amount :SomeFloat) :SomeFloat=
  if val > target: max(val - amount, target) else: min(val + amount, target)
#___________________
template apprZero*(val :SomeFloat) :bool=  val.abs < Epsilon

