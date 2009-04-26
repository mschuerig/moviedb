dojo.provide('aiki.form._ModificationEventsMixin');

dojo.declare('aiki.form._ModificationEventsMixin', null, {
  // summary:
  //   Fire events onChange, onModified, and onReverted.
  //
  // NOTE: This mixin expects that the class it is mixed into provides
  // an isModified() method.
  //
  watchForChanges: function() {
    // summary:
    //   start watching for changes to the form.
    // tags:
    //   protected
    var self = this;
    this.unwatchForChanges();
    var conns = this._watchConnections;
    dojo.forEach(this.getDescendants(), function(widget) {
      conns.push(self.connect(widget, 'onChange',
        dojo.hitch(self, '_onDescendantChange', widget)));
    });
  },

  unwatchForChanges: function() {
    // summary:
    //   stop watching for changes to the form.
    // tags:
    //   protected
    if (this._watchConnections) {
      dojo.forEach(this._watchConnections, dojo.disconnect);
    }
    this._watchConnections = [];
  },

  markUnmodified: function() {
    // tags:
    //   protected
    this._wasModified = false;
  },

  _onDescendantChange: function(widget) {
    this.onChange(widget);
    this.checkIfModified();
  },

  checkIfModified: function() {
    // tags:
    //   protected
    var modified = this.isModified();
    if (modified !== this._wasModified) {
      if (modified) {
        this.onModified();
      } else {
        this.onReverted();
      }
    }
    this._wasModified = modified;
  },

  onChange: function() {
    // tags:
    //   callback
    console.log('*** FORM ON CHANGE'); //### REMOVE
  },
  onModified: function() {
    // tags:
    //   callback
    console.log("*** FORM ON MODIFIED"); //### REMOVE
  },
  onReverted: function() {
    // tags:
    //   callback
    console.log("*** FORM ON REVERTED"); //### REMOVE
  }
});
