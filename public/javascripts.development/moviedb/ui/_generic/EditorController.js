dojo.provide('moviedb.ui._generic.EditorController');

dojo.declare('moviedb.ui._generic.EditorController', null, {
  constructor: function(store, object, view) {
    this.store = store;
    this.object = object;
    this.view = view;

    this.view.formNode.populate(this.store, this.object);
  },

  relay: function(dest) {
    aiki.relay(this.view.formNode, dest,
      'onCreated', 'onSaved', 'onError', 'onChange', 'onModified', 'onReverted');
  },

  getTitle: function() {
    return this.view.titleNode ? this.view.titleNode.attr('value') : this.view.loadingLabel;
  },

  isModified: function() {
    return this.view.formNode.isModified();
  }
});
