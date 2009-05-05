dojo.provide('moviedb.ui._MovieEditor.Controller');

dojo.declare('moviedb.ui._MovieEditor.Controller', null, {
  constructor: function(store, object, view) {
    this.store = store;
    this.object = object;
    this.view = view;

    this.view.formNode.populate(this.store, this.object);
  },

  relay: function(dest) {
    aiki.relay(this.view.formNode, dest, 'onChange', 'onModified', 'onReverted');
  },

  getTitle: function() {
    return this.view.titleNode ? this.view.titleNode.attr('value') : this.view.loadingLabel;
  },

  isModified: function() {
    return this.view.formNode.isModified();
  }
});
