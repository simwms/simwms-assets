`import Ember from 'ember'`
`import layout from '../templates/components/map-grid-polyline'`
`import GridElement from '../mixins/grid-element'`
`import Geometry from '../utils/geometry'`

{Component, computed, get, isBlank} = Ember
{alias, gt} = computed

MapGridPolylineComponent = Component.extend GridElement,
  layout: layout
  shapeType: "polyline"
  hasThickness: gt "thickness", 0
  thickness: alias "model.thickness"
  thicknessPoints: computed "points.[]", "thickness",
    get: ->
      points = @get "points"
      thickness = @get "thickness"
      return if isBlank(points) or isBlank(thickness)
      Geometry.curveAroundLine points, thickness

  thicknessPointsString: computed "thicknessPoints.[]", "pixelsPerLength",
    get: ->
      k = @get "pixelsPerLength"
      @get "thicknessPoints"
      .map (point) -> "#{k * get(point, "x")},#{k * get(point, "y")}"
      .join " "

`export default MapGridPolylineComponent`
