
dependencies = {
  // this removes some silly options from base.js
  silly: "off",

  // this removes some redundant code from base.js
  redundant: "off",

  // this removes some aliases, mostly deemed usedless.
  compat: "off",

  // disable dojo.conflict() usage (off disables)
  conflict: "off",

  // set to "on" to make djConfig.conflict moot, and always call dojo.conflict() once
  autoConflict: "off",

  // set to "off" to disable dojo.query("<div><p></p></div>") capabilities
  // (slight performance hit for having it "on")
  magicQuery: "off",

  // set to "off" to disable populating the $ with every public dojo function.
  // if "on", and the magic.js module is included, functions like $.xhr(), $.byId(),
  // $.hitch() and all other base Dojo API's are available. (requires conflict:true)
  superMagic: "off",

  // standard build options:
  optimize:"shrinksafe.keepLines",
  layerOptimize:"shrinksafe.keepLines",
  cssOptimize: "comments.keepLines",
  stripConsole:"normal",
  action:"clean,release",

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
    ["dojox", "../dojox"],
	["plugd", "../plugd"]
  ]
}
