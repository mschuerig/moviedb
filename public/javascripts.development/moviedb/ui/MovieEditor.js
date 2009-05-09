dojo.provide('moviedb.ui.MovieEditor');
dojo.require('dijit._Container');
dojo.require('moviedb.ui._generic.Editor');
dojo.require('moviedb.ui._MovieEditor.View');
dojo.require('moviedb.ui.PersonItem');
dojo.require('aiki.SortedList');

dojo.declare('moviedb.ui.MovieEditor',
  [moviedb.ui._generic.Editor, moviedb.ui._MovieEditor.View, dijit._Container], {
  
  postCreate: function() {
    this.inherited(arguments);
    this.actorsNode.attr('items', this.store.getValues(this.object, 'actors'));
  }
});
