dojo.provide('aiki.form._DataMixin');

dojo.declare('aiki.form._DataMixin', null, {
  // summary:
  //   Functions for connecting a form to data store items.
  //
  object: null,
  store: null,

  populate: function(store, object) { //### TODO options, not positional params
    if (object) {
      store.loadItem({
        item: object,
        scope: this,
        onItem: function(loadedObject) {
          this.attr('value', loadedObject);
          this.onPopulated(loadedObject);
        }
      });
    } else {
      this.attr('value', {});
      this.onPopulated();
    }
    this.object = object;
    this.store = store;
  },

  save: function() {
    var onComplete;
    if (this.object) {
      onComplete = this.onSaved;
      this._writeBackValues(dojo.hitch(this, function(prop, value) {
        this.store.setValue(this.object, prop, value);
      }));
    } else {
      onComplete = dojo.hitch(this, function() { this.onCreated(); this.onSaved(); }); //### TODO pass through args
      var newItem = {};
      this._writeBackValues(function(prop, value) {
        newItem[prop] = value;
      });
      this.object = this.store.newItem(newItem);
    }
    this.store.save({
      onComplete: onComplete,
      onError: this.onError,
      scope: this
    });
  },

  _writeBackValues: function(setter) {
    var values = this.attr('value');
    for (var prop in values) {
      var value = values[prop];
      if (dojo.config.isDebug) {
        console.debug('Setting value for ', prop, ' to ', value);
      }
      setter(prop, value);
    }
  },

  isModified: function() {
    if (!this.object) {
      return false;
    }
    var modified = false;
    var values = this.attr('value');
    for (prop in values) {
      if (!modified || dojo.config.isDebug) {
        var propModified;
        var orig = this.store.getValue(this.object, prop) || '';
        var cur = values[prop] || ''; //### TODO is '' ever used?
        if (orig instanceof Date || cur instanceof Date) {
          propModified = (dojo.date.compare(orig, cur) !== 0);
        } else {
          propModified = orig.toString() != cur.toString();
        }
        if (propModified && dojo.config.isDebug) {
          console.debug('modified property: ', prop, "\noriginal value: ", orig, "\ncurrent value: ", cur);
        }
        modified = modified || propModified;
      }
    };
    return modified;
  },

  onPopulated: function(item) {
    // tags:
    //   callback
  },
  onCreated: function() {
    // tags:
    //   callback
  },
  onSaved: function() {
    // tags:
    //   callback
  },
  onError: function() {
    // tags:
    //   callback
    console.error(arguments); //### REMOVE
  }
});
