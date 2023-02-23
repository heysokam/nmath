#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# External dependencies
import pkg/vmath
# ndk dependencies
import nstd/types as base
# Module dependencies
import ./types

#______________________________
# vmath.extend
#______________________________
template gvec2*[T](x :T) :GVec3[T]=  gvec3[T](x, x, x)
template gvec3*[T](x :T) :GVec3[T]=  gvec3[T](x, x, x)
template gvec4*[T](x :T) :GVec3[T]=  gvec3[T](x, x, x)
#____________________
proc  `<` *[T](a, b :GVec3[T]) :bool=  a[0]  < b[0] and a[1]  < b[1] and a[2]  < b[2]
proc  `>` *[T](a, b :GVec3[T]) :bool=  a[0]  > b[0] and a[1]  > b[1] and a[2]  > b[2]
proc `<=` *[T](a, b :GVec3[T]) :bool=  a[0] <= b[0] and a[1] <= b[1] and a[2] <= b[2]
proc `>=` *[T](a, b :GVec3[T]) :bool=  a[0] >= b[0] and a[1] >= b[1] and a[2] >= b[2]
# proc `==` *[T](a, b :GVec3[T]) :bool=  a[0] == b[0] and a[1] == b[1] and a[2] == b[2]
proc `==` *[T](a :GVec3[T]; b :T) :bool=  a[0] == b and a[1] == b and a[2] == b
#______________________________
proc toTuple *[T](v :GVec3[T]) :(f64, f64, f64)=  (v.x, v.y, v.z)
#______________________________
proc clamp *[T](v, minv, maxv :GVec3[T]) :GVec3[T]=  v.min(maxv).max(minv)
  ## Clamps the value of each component of vector v,
  ## to be in the range between the components of vectors minv and maxv
#______________________________
proc tripleProd *[T](a,b,c :GVec3[T]) :GVec3[T]=  a.cross(b).cross(c)
  ## (AB x AO) x AB  :  Where a = AB, b = AO, and c = AB
  ## Finds the perpendicular vector of AB, facing towards O
#______________________________
proc sameDir *[T](v1, v2 :GVec3[T]) :bool=  v1.dot(v2) > 0
  ## Check if vector1 is facing towards the same direction as vector2
#______________________________
proc sign *[T](v :GVec3[T]) :GVec3[T]=
  ## Returns a vector containing the sign (-1 or 1) of each of the input vector components.
  result[0] = v[0].sign
  result[1] = v[1].sign
  result[2] = v[2].sign


#______________________________
func up*[T](v :GVec2[T]) :GVec2[T]=  gvec2[T](0,1)
func up*[T](v :GVec3[T]) :GVec3[T]=  gvec3[T](0,1,0)


#______________________________
func appr*(val, target, amount :f32) :f32 =
  if val > target: max(val - amount, target) else: min(val + amount, target)
#___________________
template apprZero*(val :f32) :bool= val.abs < Epsilon
