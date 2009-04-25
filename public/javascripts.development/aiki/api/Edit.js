dojo.provide("aiki.api.Edit");

dojo.declare("aiki.api.Edit", aiki.api.View, {

  getFeatures: function(){
	return {
	  "aiki.api.View": true,
	  "aiki.api.Edit": true
	};
  },

  isModified: function() {
    throw new Error('Unimplemented API: aiki.api.Edit.isModified');
  },
  onChange: function() {
    throw new Error('Unimplemented API: aiki.api.Edit.onChange');
  },
  onModified: function() {
    throw new Error('Unimplemented API: aiki.api.Edit.onModified');
  },
  onReverted: function() {
    throw new Error('Unimplemented API: aiki.api.Edit.onReverted');
  }
});
