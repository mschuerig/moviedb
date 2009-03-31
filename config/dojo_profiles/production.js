
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
    //### TODO add copyright file
    ["moviedb", "../../../public/javascripts.development/moviedb"],
    ["dijit", "../dijit"],
    ["dojox", "../dojox"]
  ]
}
