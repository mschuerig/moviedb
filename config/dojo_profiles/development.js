
dependencies = {
  layers: [
    {
      name: "../moviedb/movies.js",
      layerDependencies: [],
      dependencies: [
        "moviedb.movies"
      ]
    }
  ],
  prefixes: [
    ["moviedb", "../../../public/javascripts/moviedb"],
    ["dijit", "../dijit"],
    ["dojox", "../dojox"]
  ]
}
