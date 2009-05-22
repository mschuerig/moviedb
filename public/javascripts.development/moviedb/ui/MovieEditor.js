dojo.provide('moviedb.ui.MovieEditor');
dojo.require('dijit._Container');
dojo.require('moviedb.ui._generic.Editor');
dojo.require('moviedb.ui._MovieEditor.Controller');
dojo.require('moviedb.ui._MovieEditor.View');
dojo.require('moviedb.ui.ActorItem');
dojo.require('moviedb.ui.PersonItem');
dojo.require('moviedb.schema');
dojo.require('aiki.SortedList');
dojo.require('aiki.SortedTable');

dojo.declare('moviedb.ui.MovieEditor',
  [moviedb.ui._generic.Editor, dijit._Container, 
   moviedb.ui._MovieEditor.View], {

  objectClass: moviedb.Movie,

  postCreate: function() {
    this.inherited(arguments);

    this._dispatcher = new moviedb.Dispatcher(this.domNode,
      { event: 'click', path: '.person a',    topic: 'person.selected' },
      { event: 'click', path: '.character a', topic: 'character.selected' }
    );
  },

  _makeController: function() {
    return new moviedb.ui._MovieEditor.Controller(this.store, this.object, this);
  }

});
