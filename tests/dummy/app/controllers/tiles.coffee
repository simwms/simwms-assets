`import Ember from 'ember'`

TilesController = Ember.Controller.extend
  tiles: [
    {title: "Echo", artist: "GigaP", background: "assets/images/ahegao.jpg"},
    {title: "From Dusk 'Til Dawn", artist: "Abington School Boys"},
    {title: "Trust You", artist: "Yuna Ito", background: "assets/images/snsd.jpg"}
  ]

  actions:
    star: (tile) ->
      alert "you tried to star #{tile.title} - #{tile.artist}"
    click: (tile) ->
      alert "tile clicked #{tile.title} - #{tile.artist}"

`export default TilesController`