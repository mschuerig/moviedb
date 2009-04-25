dojo.provide("aiki.api.View");

dojo.declare("aiki.api.View", null, {

  getFeatures: function(){
	return {
	  "aiki.api.View": true
	};
  },

  getTitle: function() {
    throw new Error('Unimplemented API: aiki.api.View.getTitle');
  }
});
