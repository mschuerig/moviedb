dojo.provide("moviedb.tests.robotTests");

try {
  if(dojo.isBrowser){
    var userArgs = window.location.search.replace(/[\?&](dojoUrl|testUrl|testModule)=[^&]*/g,"").replace(/^&/,"?");

    doh.registerUrl("moviedb/tests/ui/test_ActorItem.html",
      dojo.moduleUrl("moviedb", "tests/ui/test_ActorItem.html" + userArgs, 99999999));
  }
} catch(e) {
  doh.debug(e);
}
