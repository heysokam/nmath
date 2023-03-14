#:_____________________________________________________
#  nmath  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:_____________________________________________________


#______________________________
proc clamp *(v, a,b :SomeNumber) :SomeNumber=
  ## Restricts the given number to be inside range[a..b]
  if   v < a: result = a
  elif v > b: result = b
  else:       result = v

