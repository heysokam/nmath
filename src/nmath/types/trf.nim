#:_____________________________________________________
#  nmath  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:_____________________________________________________
# Module dependencies
import ./vec

#______________________________
# Transform
#___________________
type Trf *[T]= ref object of RootObj
  ## Base Transform type
#___________________
type TransformEuler *[T]= ref object of Trf[T]
  ## Euler angles transform with Uniform scaling.
  ## Contains Position, Rotation and Scale.
  ## Uses PType for its components.
  pos  *:GVec3[T]  ## Position vector
  rot  *:GVec3[T]  ## Rotation vector
  scl  *:T         ## Not vec, so Uniform scaling

#____________________
type Transform *[T]= TransformEuler[T]
  ## Transform type used globally in the lib
  #  Done with alias to allow changing the Transform type format and functionality.
  #  e.g. switching from Euler to Rotors, Quats, Matrices or Basis+Position
  #  Mainly for debugging/development, rotation types should stay the same when this is settled.
