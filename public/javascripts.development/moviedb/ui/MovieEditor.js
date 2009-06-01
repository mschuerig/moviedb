dojo.provide('moviedb.ui.MovieEditor');
dojo.require('dijit._Container');
dojo.require('moviedb.ui._generic.Editor');
dojo.require('moviedb.ui._MovieEditor.Controller');
dojo.require('moviedb.ui._MovieEditor.View');
dojo.require('moviedb.schema');
dojo.require('moviedb.Dispatcher');
dojo.require('aiki.SortedList');
dojo.require('aiki.SortedTable');

dojo.declare('moviedb.ui.MovieEditor',
  [moviedb.ui._generic.Editor, dijit._Container, 
   moviedb.ui._MovieEditor.View], {

  objectClass: moviedb.Movie,

  postCreate: function() {
    this.inherited(arguments);

    this._dispatcher = new moviedb.Dispatcher(this.domNode,
      { event: 'click', path: 'a .person',    topic: 'person.selected' },
      { event: 'click', path: 'a .character', topic: 'character.selected' }
    );
  },

  _makeController: function() {
    return new moviedb.ui._MovieEditor.Controller(this.store, this.object, this);
  }

});

(function() {
  function invertName(n) {
    var m = /(?:(.*)\s+)?(.+)$/.exec(n)
    return m[2] + '|' + m[1];
  }

  moviedb.ui.MovieEditor.creditedAsCompare = function(a, b) {
    return invertName(a.creditedAs).localeCompare(invertName(b.creditedAs));
  };

  moviedb.ui.MovieEditor.characterCompare = function(a, b) {
    return invertName(a.character.name).localeCompare(invertName(b.character.name));
  };

})();

