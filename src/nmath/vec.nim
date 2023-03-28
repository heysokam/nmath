#:_____________________________________________________
#  nmath  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:_____________________________________________________
# External dependencies
import pkg/vmath
# ndk dependencies
import nstd/types as base
# Module dependencies
import ./types

#______________________________
# vmath.extend
#______________________________
template gvec2*[T](x :T) :GVec2[T]=  gvec2[T](x, x)
template gvec3*[T](x :T) :GVec3[T]=  gvec3[T](x, x, x)
template gvec4*[T](x :T) :GVec4[T]=  gvec4[T](x, x, x, x)
#____________________
template vec2*(x,y     :SomeNumber) :Vec2=  vec2(x.float32, y.float32)
template vec3*(x,y,z   :SomeNumber) :Vec3=  vec3(x.float32, y.float32, z.float32)
template vec4*(x,y,z,w :SomeNumber) :Vec4=  vec4(x.float32, y.float32, z.float32, w.float32)
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
proc zdot  *(v1,v2 :Vec3) :f32=  max(0, v1.dot(v2))
  ## Returns the v1.dot(v2) clamped to a minimum value of 0.
proc nzdot *(v1,v2 :Vec3; epsilon :f32= 0.00001) :f32=  max(v1.dot(v2), epsilon)
  ## Returns v1.dot(v2), clamped to a mimimum of epsilon (default: 0.00001) to avoid div by 0.
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
