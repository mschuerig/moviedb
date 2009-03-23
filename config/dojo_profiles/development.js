
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
//    ["moviedb", "../../../public/javascripts/moviedb"],
    ["moviedb", "/home/michael/projects/moviedb/public/javascripts/moviedb"],
    ["dijit", "../dijit"],
    ["dojox", "../dojox"]
  ]
}
