#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# External dependencies
import pkg/vmath

#______________________________
# Axis Aligned Bounds
#___________________
type Bounds *[T]= object
  ## Bounds = mins/maxs points of an axis aligned box
  ## Also called AABB in other engines
  ## The Bounds structure does not represent an AABB in this engine.
  ## AABB is considered to be a physics object, and therefore has a position in space.
  mins  *:GVec3[T]
  maxs  *:GVec3[T]

