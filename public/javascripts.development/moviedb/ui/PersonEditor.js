dojo.provide('moviedb.ui.PersonEditor');
dojo.require('moviedb.ui._generic.Editor');
dojo.require('moviedb.ui._PersonEditor.View');
dojo.require('moviedb.ui.SpouseItem');
dojo.require('moviedb.Dispatcher');

dojo.declare('moviedb.ui.PersonEditor', [moviedb.ui._generic.Editor, moviedb.ui._PersonEditor.View], {

  postCreate: function() {
    this.inherited(arguments);

    this._dispatcher = new moviedb.Dispatcher(this.domNode,
      { event: 'click', path: 'a .person', topic: 'person.selected' },
      { event: 'click', path: 'a .movie',  topic: 'movie.selected' }
    );
  },

  getTitle: function() {
    return this.firstnameField.attr('value') + ' ' + this.lastnameField.attr('value');
  }

});
