#:_____________________________________________________
#  nmath  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:_____________________________________________________
# External dependencies
import pkg/vmath
# n*math dependencies
import ./types
import ./vec

#____________________
# TODO: fix this tuple+number function
proc gvec3 *[T](t :tuple[pitch, yaw :T]; n :T) :GVec3[T]= gvec3(t.pitch, t.yaw, n)
#____________________
proc angles *[T](a :GVec3[T]) :(T, T)=
  ## Given a 3d vector, computes its pitch and yaw angles
  ## Converts from Cartesian x,y,z to Spherical pitch, yaw
  ## Assumes OpenGL (+X.right, +Y.up, +Z.back) coordinate system
  let pitch = arctan2(sqrt(a.x^2 + a.y^2), a.z)
  let yaw   = arctan2(a.y, a.x)
  return (pitch, yaw)

#____________________
proc angles *[T](origin, target :GVec3[T]) :(T, T)=
  ## Computes pitch and yaw starting at origin and looking at target.
  angles(target - origin)

#____________________
proc angles *[T](m :GMat4[T]) :GVec3[T]=
  ## Return pitch, yaw and roll of a matrix.
  ## Assumes OpenGL (+X.right, +Y.up, +Z.back) coordinate system
  let pitch = arctan2(-m[2][0], sqrt(m[2][1]^2 + m[2][2]^2))
  let yaw   = arctan2( m[2][1], m[2][2])
  let roll  = arctan2( m[1][0], m[0][0])
  gvec3[T](pitch, yaw, roll)
#____________________

#____________________
template pitch *[T](v :GVec3[T]) :T=  v.x
template yaw   *[T](v :GVec3[T]) :T=  v.y
template roll  *[T](v :GVec3[T]) :T=  v.z
#____________________
# Multiplication order for rotation  (applied from right to left)
#   target = yaw * pitch * roll * lookDir
# Rotation is applied along the world basis axes, not around the body axes
# This makes the order important:
#   yaw->pitch  : The pitch part is now a roll from the body's point of view
#   pitch->yaw  : Behaves as expected
#____________________
proc target *[T](v :GVec3[T]) :GVec3[T]=
  ## Returns the normalized target vector that the pitch/yaw input angles will create
  ## Assumes OpenGL (+X.right, +Y.up, +Z.back) coordinate system
  ## TODO: Roll component is currently ignored
  v.yaw.rotateY * v.pitch.rotateX * gvec3(0.T, 0.T, -1.T)




##[
#____________________
proc hpr *[T](m :GMat4[T]) :GVec3[T]=
  ## Return heading, rotation and pivot of a matrix.
  let heading = arctan2( m[2][1], m[2][2])
  let pitch   = arctan2(-m[2][0], sqrt(m[2][1]^2 + m[2][2]^2))
  let roll    = arctan2( m[1][0], m[0][0])
  gvec3[T](heading, pitch, roll)
#____________________
proc testHpr *()=
  # test .hpr
  doAssert Mat4().angles ~= vec3(0, 0, 0)

  doAssert rotateX(10.toRadians()).angles ~= vec3(10.toRadians(), 0, 0)
  doAssert rotateY(10.toRadians()).angles ~= vec3(0, 10.toRadians(), 0)
  doAssert rotateZ(10.toRadians()).angles ~= vec3(0, 0, 10.toRadians())

  doAssert rotateX(89.toRadians()).angles ~= vec3(89.toRadians(), 0, 0)
  doAssert rotateY(89.toRadians()).angles ~= vec3(0, 89.toRadians(), 0)
  doAssert rotateZ(89.toRadians()).angles ~= vec3(0, 0, 89.toRadians())

  doAssert rotateX(90.toRadians()).angles ~= vec3(90.toRadians(), 0, 0)
  doAssert rotateY(90.toRadians()).angles ~= vec3(0, 90.toRadians(), 0)
  doAssert rotateZ(90.toRadians()).angles ~= vec3(0, 0, 90.toRadians())

  doAssert rotateX(-90.toRadians()).angles ~= vec3(-90.toRadians(), 0, 0)
  doAssert rotateY(-90.toRadians()).angles ~= vec3(0, -90.toRadians(), 0)
  doAssert rotateZ(-90.toRadians()).angles ~= vec3(0, 0, -90.toRadians())

  doAssert rotateX(180.toRadians()).angles ~= vec3(-180.toRadians(), 0, 0)
  doAssert rotateZ(180.toRadians()).angles ~= vec3(0, 0, -180.toRadians())

  doAssert rotateX(-180.toRadians()).angles ~= vec3(180.toRadians(), 0, 0)
  doAssert rotateZ(-180.toRadians()).angles ~= vec3(0, 0, 180.toRadians())

  echo lookAt(vec3(0, 0, 0), vec3(1, 0, 0)).angles
]##

#____________________
# Cartesian to Spherical coordinates Calculator
# Converts from Cartesian (x,y,z) to Spherical (r,θ,φ) coordinates in 3-dimensions.
# https://keisan.casio.com/exec/system/1359533867
#____________________

#____________________
# Alternative answer, using matrices (requires an input vector v)
# let result :Vec3=  Rz * Rx * v  # Probably uses the incorrect coordinate system, and therefore be wrong
# E.g. if "forward" is +Y for an un-rotated player, then your new forward direction is
# fwd = M * y
# forwardDir :Vec3= rotateAroundUpAxis( yawAngle ) * rotateAroundRightAxis( pitchAngle ) * vec3(forwBasis)
# #____________________

#____________________
#            right handed       X.forw                 Y.left        Z.up
#Vector3 forward = { cos(pitch) * cos(yaw), cos(pitch) * sin(yaw), sin(pitch) }  <----- Unit vector
#____________________


#____________________
proc toAngles*[T](v :GVec3[T]) :GVec3[T]=
  ## Return the pitch/yaw/roll angles required to create the input vector
  ## Assumes (+right, +up, +back) coordinate system. TODO: Convert to (right, forw, up)
  ## Normalizes the input
  let norm = v.normalize
#____________________
proc toDir*[T](v :GVec3[T]) :GVec3[T]=
  ## Return the normalized target vector that the pitch/yaw/roll input angles will create
  ## Assumes (+right, +up, +back) coordinate system. TODO: Convert to (right, forw, up)
  discard


#____________________
# I'll use right-handed x,y,z Cartesian coordinates.
# I visualize roll, pitch, and yaw using the motion of someone's right hand,
# whose thumb and index finger are kept at right angles.
#
# We start out with 
# : index finger of pointing in the direction (0,1,0)T (positive y axis) 
# : thumb pointing in the direction (0,0,1)T (positive z axis). 
# We turn the entire hand by the yaw angle (θ) counterclockwise around the z axis. 
# We then rotate the hand in the plane now occupied by the index finger and thumb, 
# turning it by the pitch angle (ϕ) with the index finger moving in the direction of the thumb.
#
# At this point the angles pitch and yaw describe the direction of the index finger in something like geographic coordinates, 
# where pitch corresponds to latitude and yaw corresponds to longitude.
# Note: These are not "mathematical" spherical coordinates, 
#       where ϕ (our pitch) is the angle of a vector relative to the z-axis
#
# Finally, we rotate the hand using the direction of the index finger as the axis of rotation, 
# turning the thumb toward the palm of the hand by an angle roll (ψ)
#
# The effect of these motions on a vector "attached" to the hand can be represented by a 3×3 matrix. 
# We can decompose this matrix into a product of three much simpler matrices. 
# Each of these three matrices will be a rotation around one of the principal axes (x, y, or z axes), 
# unlike the pitch and roll motions described above, which were performed around axes relative to an already-rotated hand.
#
# To reproduce the result of the roll, pitch, and yaw on the orientation of the hand, 
# using rotations only around the principal axes, 
# we have to do the rotations in reverse order. 
# This is so that we can still do pitch and roll around the correct axes relative to the hand, 
# but do them while those axes are still aligned with the principal axes.
#
# We do the "roll" through angle ψ first, using the matrix
# Ry(ψ) = ( cosψ, 0, sinψ,
#              0, 1,    0,
#          −sinψ, 0, cosψ)
# (a rotation around the y-axis), 
#
# then the "pitch" through angle ϕ, using the matrix
# Rx(ϕ) = ( 1,     0,    0,
#           0,  cosϕ, sinϕ,
#           0, −sinϕ, cosϕ)
# (rotation around the x-axis)
#
# and the "yaw" through angle θ, using the matrix
# Rz(θ) = ( cosθ, −sinθ, 0, 
#           sinθ,  cosθ, 0, 
#              0,     0, 1)
# (a rotation around the z-axis). 

# These are much like the axis-rotation matrices used in several other places (including my earlier answer), 
# but with a sequence of axes and signs of the matrix entries suitable to your system.
#
# The best way to understand how this works may be to try several examples, 
# using simple pitch, roll, and yaw angles such as π/2 or π/4, 
# and confirm that this sequence of rotations around fixed principal coordinate axes 
# has the same result as the desired sequence of rotations around axes defined by the orientation of the hand.
#
# This sequence of rotations is equivalent to the single rotation performed by the matrix product 
#   Rz(θ)Ry(ϕ)Rx(ψ). 
#
# Here's what this rotation does to the direction of the index finger, (0,1,0)T:
# Rz(θ) * Rx(ϕ) * Ry(ψ) * (0, 1, 0)
# = Rz(θ) * Rx(ϕ) 
#   * (cosψ, 0, sinψ, 0, 1, 0, −sinψ, 0, cosψ) * (0, 1, 0) 
# = Rz(θ) * Rx(ϕ) * (0, 1, 0)
# = Rz(θ) * (1, 0, 0, 0, cosϕ, sinϕ, 0, −sinϕ, cosϕ) * (0, 1, 0)
# = Rz(θ) * (0, cosϕ, sinϕ)
# = (cosθ, −sinθ, 0, sinθ, cosθ, 0, 0, 0, 1) * (0, cosϕ, sinϕ)
# = (cosϕ*sinθ, cosϕ*cosθ, sinϕ)
#
# What this same rotation does to the direction of the thumb, (0,0,1)T, is
# Rz(θ) * Rx(ϕ) * Ry(ψ) * (0,0,1)
# = Rz(θ) * Rx(ϕ)
#   * ( cosψ, 0,  sinψ,
#          0, 1,     0,
#      −sinψ, 0,  cosψ)
#   * (    0, 0,     1)
#
# = Rz(θ) * Rx(ϕ) * (−sinψ, 0, cosψ)
#
# = Rz(θ)
#   *(    1,     0,    0,
#         0,  cosϕ, sinϕ,
#         0, −sinϕ, cosϕ)
#   *(−sinψ,     0, cosψ)
# = Rz(θ) * (−sinψ, −cosψ*sinϕ, cosψ*cosϕ)
# = ( cosθ, −sinθ,     0,
#     sinθ,  cosθ,     0,
#        0,     0,     1)
#  *(−sinψ, −cosψ*sinϕ, cosψ*cosϕ)
# = (−sinψ * cosθ * −cosψ * sinϕ * sinθ,
#     sinψ * sinθ * −cosψ * sinϕ * cosθ,
#     cosψ * cosϕ)
