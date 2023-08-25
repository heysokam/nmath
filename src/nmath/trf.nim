#:_____________________________________________________
#  nmath  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:_____________________________________________________
# std dependencies
import std/strformat
# n*dk dependencies
import nstd/types
# n*math dependencies
import ./types/trf
import ./types/vec

#_____________________________
proc newTransform *[T]() :Transform[T]=  Transform[T]()

#_____________________________
proc `$` *[T :Trf](trf :T) :str=
  ## Converts the given Transform to a string containing pos, rot and scl
  mixin pos, rot, scl
  fmt"{$T} (position: {$trf.pos}, rotation: {$trf.rot}, scale: {$trf.scl}"
  # https://nim-lang.org/docs/manual.html#generics-mixin-statement

#__________________________________________________
template right*(m :Mat4) :Vec3=  vec3(m[0, 0], m[0, 1], m[0, 2])
template up   *(m :Mat4) :Vec3=  vec3(m[1, 0], m[1, 1], m[1, 2])
template forw *(m :Mat4) :Vec3=  vec3(m[2, 0], m[2, 1], m[2, 2])


#__________________________________________________________
# Potential types examples
runnableExamples:
  #______________________________
  type AlwaysZero = object of Trf

  proc pos *(alwaysZero :AlwaysZero) :PVec3= discard
  proc rot *(alwaysZero :AlwaysZero) :PVec3= discard
  proc scl *(alwaysZero :AlwaysZero) :PVec3= discard

  echo $AlwaysZero()


  #______________________________
  type Normal = object of Trf
    pos, rot, scl: Vec3

  echo Normal(pos: vec3(10f, 20, 30), rot: vec3(1,1,1), scl: vec3(1f, 1, 1))
