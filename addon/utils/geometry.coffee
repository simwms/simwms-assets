`import Ember from 'ember'`

{A, get} = Ember

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

class Geometry
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
