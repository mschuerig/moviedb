dojo.provide("moviedb.api.View");

dojo.declare("moviedb.api.View", null, {

  getFeatures: function(){
	return {
	  "moviedb.api.View": true
	};
  },

  getTitle: function() {
    throw new Error('Unimplemented API: moviedb.api.View.getTitle');
  }
});
