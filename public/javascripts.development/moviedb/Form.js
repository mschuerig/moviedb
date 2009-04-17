
dojo.provide('moviedb.Form');

dojo.declare('moviedb.Form', dijit.form.Form, {
  //### TODO
  // - derive appropriate widgets and validations from a json schema
  // - propertiesMap: convention|explicit map|mapping function
  // - don't overwrite callback methods, leave them to users
  movie: null,
  store: null,
  propertiesMap: {
    'movie_title': 'title',
    'movie_release_date': 'releaseDate',
    'movie_summary': 'summary'
  },
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
          self._for_properties(function(prop, widget) {
            widget.setValue(store.getValue(loadedMovie, prop));
          });
        }
      });
    } else {
      for (var prop in this.propertiesMap) {
        dijit.byId(prop).setValue(null);
      }
    }
    this._lastChanged = false;
    this.movie = movie;
    this.store = store;
    this._resetSubmitButton();
    console.log('*** POPULATE EXIT'); //### REMOVE
  },
  save: function() {
    if (this.movie) {
      this._for_properties(function(prop, widget) {
        this.store.setValue(this.movie, prop, widget.attr('value'));
      });
      this.store.save({
        onComplete: this.onSaved,
        scope: this
      });
    }
  },
  onSaved: function() {
    console.log('***** SAVED'); //### REMOVE
    this._resetSubmitButton();
  },
  isChanged: function() {
    if (!this.movie) return false;
    var changed = false;
    this._for_properties(function(prop, widget) {
      if (!changed) {
        var orig = this.store.getValue(this.movie, prop) || '';
        var cur = widget.attr('value') || '';
        changed = orig.toString() != cur.toString();
/*
      console.log('* ORIG: ', orig, "\nCUR: ", cur, "\nEQ: ",
                  cur.toString() == orig.toString());
*/
      }
    });
    console.log("*** is changed: ", changed); //### REMOVE
    return changed;
  },
  connectChildren: function() {
    this.inherited(arguments);
    var self = this;
    var conns = this._changeConnections;
    dojo.forEach(this.getDescendants(), function(widget) {
      conns.push(self.connect(widget, 'onBlur',
        dojo.hitch(self, '_checkForChange', widget)));
    });
  },
  _checkForChange: function(widget) {
    console.log('*** check for change'); //### REMOVE
    var changed = this.isChanged();
    if (changed !== this._lastChanged) {
      if (changed) {
        this.onChange();
      } else {
        this.onRevert();
      }
    }
    this._lastChanged = changed;
  },
  _for_properties: function(f) {
    var propertiesMap = this.propertiesMap;
    f = dojo.hitch(this, f);
    for (var prop in propertiesMap) {
      f(propertiesMap[prop], dijit.byId(prop));
    }
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
    console.log("*** ON CHANGE");
  },
  onRevert: function() {
    console.log("*** ON REVERT");
  }
});
