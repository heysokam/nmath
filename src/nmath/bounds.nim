#:_____________________________________________________
#  nmath  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:_____________________________________________________
# External dependencies
import pkg/vmath
# Module dependencies
import ./types
import ./vec


#______________________________
# Bounds: Getter aliases
proc xt *[T](bbox :Bounds[T]) :GVec3[T]=  (bbox.mins - bbox.maxs) / 2
  ## Returns the positive extents of the given bounding box
proc center *[T](bbox :Bounds[T]) :GVec3[T]=  (bbox.mins + bbox.maxs) / 2
  ## Returns center point of the given bounding box
proc centerXt *[T](bbox :Bounds[T]) :(GVec3[T], GVec3[T])= (bbox.center, bbox.xt)
  ## Returns a tuple containing the center and positive extents of the input bounds


#______________________________
# Constructors
proc newBounds *(T :typedesc)            :Bounds[T]=  Bounds[T](mins: gvec3[T](0.T), maxs: gvec3[T](0.T))
proc newBounds *[T](val :T)              :Bounds[T]=  Bounds[T](mins: gvec3[T](-val), maxs: gvec3[T](val))
proc newBounds *[T](v1,v2,v3 :T)         :Bounds[T]=  Bounds[T](mins: gvec3[T](-v1, -v2, -v3), maxs: gvec3[T](v1, v2, v3))
proc newBounds *[T](vec :GVec3[T])       :Bounds[T]=  Bounds[T](mins: -vec, maxs: vec)
proc newBounds *[T](mins,maxs :GVec3[T]) :Bounds[T]=  Bounds[T](mins: mins, maxs: maxs)
#______________________________
proc newBounds *[T](pts :seq[GVec3[T]])  :Bounds[T]=
  ## Calculates the Bounds of the given set of points.
  for pt in pts:                       # For each point
    result.mins = pt.min(result.mins)  # Store each component if its less than the current
    result.maxs = pt.max(result.maxs)  # Store each component if its more than the current

#______________________________
proc isZero *[T](bbox :Bounds[T]) :bool=  bbox.mins == 0 and bbox.maxs == 0
  ## Checks if all components of the bounding box are 0
#______________________________
proc valid *[T](bbox :Bounds[T]) :bool=  bbox.mins < bbox.maxs or bbox.isZero
  ## Checks if the bounding box is valid,
  ## by checking if each mins component is smaller than each respective maxs
  ## An all Zero bbox will also be considered valid (a Point has no radius and a zero bbox)
#______________________________
proc fix *[T](bbox :var Bounds[T]) :void=
  ## Checks if the bbox is valid, and swaps the bbox mins and maxs bounds when it isn't
  if   bbox.isZero: return
  elif not bbox.valid:
    let tmp = bbox.mins; bbox.mins = bbox.maxs; bbox.maxs = tmp
#______________________________
proc toVerts *[T](bbox :Bounds[T]) :seq[GVec3[T]]=
  ## Splits the given bounds into a tuple of its eight delimiting vector points
  # TODO: Which verts winding order ?
  var fi = bbox; fi.fix  # Fix input in case the values are invalid
  let mi = fi.mins       # Aliases
  let ma = fi.maxs
  # Min side
  result.add(gvec3[T](mi.x, mi.y, mi.z))
  result.add(gvec3[T](ma.x, mi.y, mi.z))
  result.add(gvec3[T](mi.x, ma.y, mi.z))
  result.add(gvec3[T](mi.x, mi.y, ma.z))
  # Max side
  result.add(gvec3[T](ma.x, ma.y, ma.z))
  result.add(gvec3[T](mi.x, ma.y, ma.z))
  result.add(gvec3[T](ma.x, mi.y, ma.z))
  result.add(gvec3[T](ma.x, ma.y, mi.z))
#______________________________
proc vertsTuple *[T](bbox :Bounds[T]) :(GVec3[T], GVec3[T], GVec3[T], GVec3[T], GVec3[T], GVec3[T], GVec3[T], GVec3[T])=
  ## Splits the given bounds into a tuple of its eight delimiting vector points
  ## Returns the verts in CCW order: top bottom front back left right
  var fi     = bbox; fi.fix  # Fix input in case the values are invalid
  let center = fi.center     # Convert to center extents
  let xt     = fi.xt
  result = (  # Counter-Clockwise
    center + gvec3[T](-xt.x,  xt.y, -xt.z),  # tfl  # Top points
    center + gvec3[T]( xt.x,  xt.y, -xt.z),  # tfr
    center + gvec3[T](-xt.x,  xt.y,  xt.z),  # tbl
    center + gvec3[T]( xt.x,  xt.y,  xt.z),  # tbr
    center + gvec3[T](-xt.x, -xt.y, -xt.z),  # bfl  # Bottom points
    center + gvec3[T]( xt.x, -xt.y, -xt.z),  # bfr
    center + gvec3[T](-xt.x, -xt.y,  xt.z),  # bbl
    center + gvec3[T]( xt.x, -xt.y,  xt.z) ) # bbr
#______________________________
proc octSplit *[T](bounds :Bounds[T]) :(Bounds[T], Bounds[T], Bounds[T], Bounds[T], Bounds[T], Bounds[T], Bounds[T], Bounds[T])=
  ## Splits the given bounds into a tuple of eight bounds,
  ## formed from its center and its eight most exterior vector points
  let (tfl, tfr, tbl, tbr, bfl, bfr, bbl, bbr) = bounds.vertsTuple()
  let center = bounds.center # Convert to center extents
  result = (
    newBounds(tfl, center), newBounds(tfr, center), newBounds(tbl, center), newBounds(tbr, center), 
    newBounds(bfl, center), newBounds(bfr, center), newBounds(bbl, center), newBounds(bbr, center)  )

