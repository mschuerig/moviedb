
dojo.provide('moviedb.Form');

dojo.declare('moviedb.Form', dijit.form.Form, {
  //### TODO
  // - derive appropriate widgets and validations from a json schema
  // - don't overwrite callback methods, leave them to users
  movie: null,
  store: null,

  constructor: function() {
    console.log('*** FORM ctor: ', arguments);
  },
  onSubmit: function() {
    if (this.isValid()) {
      this.save();
    }
    return false;
  },
  onReset: function() {
    this._resetSubmitButton();
    return this.inherited(arguments);
  },
  populate: function(store, movie) {
    if (movie) {
      var self = this;
      store.loadItem({ item: movie,
        onItem: function(loadedMovie) {
          self._forProperties(function(prop, widget) {
            widget.setValue(store.getValue(loadedMovie, prop));
          });
        }
      });
    } else {
      this._forProperties(function(prop, widget) {
        widget.setValue(null);
      });
    }
    this._wasModified = false;
    this.movie = movie;
    this.store = store;
    this._resetSubmitButton();
  },
  save: function() {
    if (this.movie) {
      this._forProperties(function(prop, widget) {
        this.store.setValue(this.movie, prop, widget.attr('value'));
      });
      this.store.save({
        onComplete: this.onSaved,
        scope: this
      });
    }
  },
  onSaved: function() {
    this._resetSubmitButton();
  },
  isModified: function() {
    if (!this.movie) return false;
    var modified = false;
    this._forProperties(function(prop, widget) {
      if (!modified) {
        var orig = this.store.getValue(this.movie, prop) || '';
        var cur = widget.attr('value') || '';
        //### TODO use dojo.date.compare() for dates
        modified = orig.toString() != cur.toString();
      }
    });
    return modified;
  },
  connectChildren: function() {
    this.inherited(arguments);
    var self = this;
    var conns = this._changeConnections;
    dojo.forEach(this.getDescendants(), function(widget) {
      conns.push(self.connect(widget, 'onBlur',
        dojo.hitch(self, '_checkIfModified', widget)));
    });
  },
  _checkIfModified: function(widget) {
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
    this.inherited(arguments);
    this.onChange(widget);
  },
  _forProperties: function(func) {
    func = dojo.hitch(this, func);
    this.getDescendants().forEach(function(widget) {
      if (widget.name) {
        func(widget.name, widget);
      }
    });
  },
  _resetSubmitButton: function() {
    this._buttons().forEach(function(button) {
      if (dojo.isFunction(button.cancel)) {
        button.cancel();
      }
    });
  },
  _buttons: function() {
    return this.getDescendants().filter(function(widget) {
      return (widget instanceof dijit.form.Button);
    });
  },
  onChange: function() {
    console.log('*** ON CHANGE');
  },
  onModified: function() {
    console.log("*** ON MODIFIED");
  },
  onReverted: function() {
    console.log("*** ON REVERTED");
  }
});
