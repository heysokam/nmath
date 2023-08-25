#:_____________________________________________________
#  nmath  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:_____________________________________________________
# n*dk dependencies
import nstd/types as baseTypes
# n*math dependencies
import ./types


# TODO: Finish converting to Generic
#
#
#____________________
# Source:  An Interactive Introduction to Rotors from Geometric Algebra, by Marc ten Bosch
# https://marctenbosch.com/quaternions/
# https://marctenbosch.com/quaternions/code.htm
#____________________

#__________________________________________________
type BiVec3 = distinct PVec3
template `[]` *(a: BiVec3; i: int) :PType= a.arr[i]
template `[]=`*(a: var BiVec3; i :int; v :PType) :void= a.arr[i] = v
template `x=` *(v :var BiVec3; val :PType) :void=  v[0] = val
template `y=` *(v :var BiVec3; val :PType) :void=  v[1] = val
template `z=` *(v :var BiVec3; val :PType) :void=  v[2] = val
#____________________
proc bivec3 *(x, y, z :PType) :BiVec3=
  result.x = x
  result.y = y
  result.z = z
#____________________
proc wedge *(u,v :PVec3) :BiVec3 {.inline.}=
  ## Wedge product
  result = bivec3(u.x * v.y - u.y * v.x,   # XY
                  u.x * v.z - u.z * v.x,   # XZ
                  u.y * v.z - u.z * v.y )  # YZ
#__________________________________________________
type Rotor = distinct PVec4
template `x=`*(v :var Rotor, val :PType) :void=  v[0] = val
template `y=`*(v :var Rotor, val :PType) :void=  v[1] = val
template `z=`*(v :var Rotor, val :PType) :void=  v[2] = val
template `w=`*(v :var Rotor, val :PType) :void=  v[3] = val
#____________________
# Default Constructors
proc rotor *(w, x, y, z :PType) :Rotor=
  result.x = x
  result.y = y
  result.z = z
  result.z = w
#____________________
proc rotor *(w :PType; b :BiVec3) :Rotor=
  result.x = b.x
  result.y = b.y
  result.z = b.z
  result.w = w
#____________________
proc rotor *(vFrom, vTo :PVec3) :Rotor=
  ## Construct the rotor that rotates one vector to another
  ## Uses the usual trick to get the half angle
  result.w = 1 + vTo.dot(vFrom)
  # The left side of the products has b a, not a b, so flip
  let minusb = vTo.wedge(vFrom)
  result.x = minusb.x
  result.y = minusb.y
  result.z = minusb.z
  result.normalize
#____________________
# angle+plane, plane must be normalized  (angle+axis)
proc rotor *(bvPlane :BiVec3; angleRadian :PType) :Rotor=  # Rotor3::Rotor3(const Bivector3 &bvPlane, float angleRadian) {
  let sina = sin(angleRadian/2)
  result.w = cos(angleRadian/2)
  # The left side of the products have b a, not a b
  result.x = -sina * bvPlane.x
  result.y = -sina * bvPlane.y
  result.z = -sina * bvPlane.z
#____________________
proc `*` *(p,q :Rotor) :Rotor=
  ## Rotor3-Rotor3 product (non-optimized)
  # Expand the geometric product rules
  result.w = p.w*q.w - p.x*q.x - p.y*q.y - p.z*q.z
  result.x = p.x*q.w + p.w*q.x + p.z*q.y - p.y*q.z
  result.y = p.y*q.w + p.w*q.y - p.z*q.x + p.x*q.z
  result.z = p.z*q.w + p.w*q.z + p.y*q.x - p.x*q.y
#____________________
proc rotate *(p :Rotor; v :PVec3) :PVec3=
  ## Rotate a vector by the rotor : R x R* (non-optimized)
  # q = P v
  var q :PVec3= vec3(
    p.w*v.x + v.y*p.x + v.z*p.y,
    p.w*v.y - v.x*p.x + v.z*p.z,
    p.w*v.z - v.x*p.y - v.y*p.z  )
  # Trivector
  let q012 :PType= v.x*p.z - v.y*p.y + v.z*p.x
  # r = q P*
  result.x = p.w*q.x +  q.y*p.x +  q.z*p.y + q012*p.z
  result.y = p.w*q.y -  q.x*p.x - q012*p.y +  q.z*p.z
  result.z = p.w*q.z + q012*p.x -  q.x*p.y -  q.y*p.z
  # Trivector part of the result is always zero
#____________________
proc `*=` *(p,r :Rotor) :Rotor {.inline.}=  p*r  ## Rotor3-Rotor3 product
#____________________
template reverse *(r :Rotor) :Rotor=  rotor3(-r.x, -r.y, -r.z, r.w)  ## Equivalent to conjugate
#____________________
proc rotate *(p,r :Rotor) :Rotor {.inline.}=  p*r*p.reverse()
  ## Rotate a rotor by another  (should unwrap this for efficiency)
#____________________
proc lenSquared *(r :Rotor) :PType=  r.w.sqr + r.x.sqr + r.y.sqr + r.z.sqr  ## Length Squared
#____________________
proc len *(r :Rotor) :Rotor=  r.lenSquared.sqr  ## Length
#____________________
proc normalize *(r :var Rotor) :void {.inline.}=
  ## Normalize the input rotor
  let l :PType= r.len()
  r.w /= l
  r.x /= l
  r.y /= l
  r.z /= l
#____________________
proc normal *(r :Rotor) :Rotor {.inline.}=  result = r; result.normalize
  ## Returns a normalized version of the input rotor
#____________________
proc toMat3 *(r :Rotor) :PMat3 {.inline.}=
  ## Converts rotor to matrix (non-optimized)
  result = mat3(r.rotate(vec3(1,0,0)),
                r.rotate(vec3(0,1,0)),
                r.rotate(vec3(0,0,1)) )
#____________________
proc geo *(a,b :PVec3) :Rotor {.inline.}=  rotor(a.dot(b), a.wedge(b))
  ## Geometric product (for reference).
  ## Produces twice the angle, negative direction.

