dojo.provide('aiki.form._ModificationEventsMixin');

dojo.declare('aiki.form._ModificationEventsMixin', null, {
  //
  // NOTE: This mixin expects that the class it is mixed into provides
  // an isModified() method.
  //
  connectChildren: function() {
    // Overrides dijit.form._FormMixin
    this.inherited(arguments);
    var self = this;
    var conns = this._changeConnections;
    dojo.forEach(this.getDescendants(), function(widget) {
      conns.push(self.connect(widget, 'onBlur',  //### TODO is onBlur a good idea? vs onChange
        dojo.hitch(self, 'checkIfModified', widget)));
    });
  },
  markUnmodified: function() {
    // tags:
    //   protected
    this._wasModified = false;
  },

  checkIfModified: function(widget) {
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

  _widgetChange: function(widget) {
    // Overrides dijit.form._FormMixin
    this.inherited(arguments);
    this.onChange(widget);
  },

  onChange: function() {
    // tags:
    //   callback
    console.log('*** ON CHANGE'); //### REMOVE
  },
  onModified: function() {
    // tags:
    //   callback
    console.log("*** ON MODIFIED"); //### REMOVE
  },
  onReverted: function() {
    // tags:
    //   callback
    console.log("*** ON REVERTED"); //### REMOVE
  }
});
