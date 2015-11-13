`import Ember from 'ember'`
`import zipWith from './zip-with'`
`import {map3} from './mapx'`

{A, get, isArray, isBlank} = Ember

xSmallerThan = (x0) -> ([x, _]) -> x < x0
xBiggerThan = (x0) -> ([x, _]) -> x > x0
ySmallerThan = (y0) -> ([_, y]) -> y < y0
yBiggerThan = (y0) -> ([_, y]) -> y > y0

enclosedBy = (points) ->
  ([x,y]) ->
    points.find( xSmallerThan x ) and
    points.find( xBiggerThan x ) and
    points.find( ySmallerThan y ) and
    points.find( yBiggerThan y )
  
squareAround = (o) ->
  x = get(o, "x")
  y = get(o, "y")
  [[x,y], [x+1, y], [x+1, y+1], [x, y+1]]

unitNormal90 = (p0, pf) ->
  return unless p0? and pf?
  x = get(pf, "x") - get(p0, "x")
  y = get(pf, "y") - get(p0, "y")
  k = Math.sqrt(x*x + y*y)
  x /= k
  y /= k
  x: y, y: -x

addVector = (v1, v2) ->
  return v2 if isBlank(v1)
  return v1 if isBlank(v2)
  x: get(v1, "x") + get(v2, "x")
  y: get(v1, "y") + get(v2, "y")

avgNormal = (pp, pv, pn) ->
  prev = unitNormal90(pp, pv)
  next = unitNormal90(pv, pn)
  addVector prev, next

shiftBy = (k) ->
  (point, direction) ->
    x: get(point, "x") + k * get(direction, "x")
    y: get(point, "y") + k * get(direction, "y")

class Geometry
  ## A line is an array of points
  ## Linear interpolation is assumed
  @curveAroundLine = (line, k) ->
    normals = map3 line, avgNormal
    console.log get(line, "length")
    console.log get(normals, "length")
    
    forwLine = zipWith line, normals, shiftBy(k)
    backLine = zipWith line, normals, shiftBy(-k)
    while (p = backLine.popObject())
      forwLine.pushObject p
    forwLine

  @componentOverlapsShape = (component, shape) ->
    model = component.get "model"
    switch component.get("shapeType")
      when "polygon", "tile"
        @polygonOverlap @normalizeModel(model), shape
      when "polyline"
        @polylineOverlap @normalizeModel(model), shape
      else return false

  @polylineOverlap = (shape1, shape2) ->
    return true if A(shape1).find enclosedBy(shape2)
    false

  ## Shapes are just arrays of points
  ## Interpolation is linear between points
  ## May mess up for convex shapes
  @polygonOverlap = (shape1, shape2) ->
    return true if A(shape1).find enclosedBy(shape2)
    return true if A(shape2).find enclosedBy(shape1)
    false

  ## Takes a model object and makes it a shape
  ## That is, an array of points
  @normalizeModel = (model) ->
    origin = get(model, "origin")
    points = get(model, "points")

    return squareAround(origin) if origin? and not points?
    points.map ({x,y}) -> [x + origin.x, y + origin.y]

`export default Geometry`
