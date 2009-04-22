dojo.provide("moviedb.api.Edit");

dojo.declare("moviedb.api.Edit", moviedb.api.View, {

  getFeatures: function(){
	return {
	  "moviedb.api.View": true,
	  "moviedb.api.Edit": true
	};
  },

  isModified: function() {
    throw new Error('Unimplemented API: moviedb.api.Edit.isModified');
  },
  onChange: function() {
    throw new Error('Unimplemented API: moviedb.api.Edit.onChange');
  },
  onModified: function() {
    throw new Error('Unimplemented API: moviedb.api.Edit.onModified');
  },
  onReverted: function() {
    throw new Error('Unimplemented API: moviedb.api.Edit.onReverted');
  }
});
