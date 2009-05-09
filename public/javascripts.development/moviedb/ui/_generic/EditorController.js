dojo.provide('moviedb.ui._generic.EditorController');

dojo.declare('moviedb.ui._generic.EditorController', null, {
  _isReady: false,
  
  constructor: function(store, object, view) {
    this.store = store;
    this.object = object;
    this.view = view;
    var whenReady = this._whenReady = new dojo.Deferred();

    dojo.connect(this.view.formNode, 'onPopulated', dojo.hitch(this, function() {
      this._isReady = true;
      whenReady.callback(view);
    }));

    this.view.formNode.populate(this.store, this.object);
  },

  relay: function(dest) {
    aiki.relay(this.view.formNode, dest,
      'onCreated', 'onSaved', 'onError', 'onChange', 'onModified', 'onReverted');
  },

  whenReady: function(/* Function? */callback) {
    if (callback) {
      this._whenReady.addCallback(callback);
    }
    return this._whenReady;
  },

  isReady: function() {
    return this._isReady;
  },

  getTitle: function() {
    return this.view.titleNode.attr('value');
  },

  isModified: function() {
    return this.view.formNode.isModified();
  }
});
