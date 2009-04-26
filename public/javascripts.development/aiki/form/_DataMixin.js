dojo.provide('aiki.form._DataMixin');

dojo.declare('aiki.form._DataMixin', null, {
  object: null,
  store: null,

  populate: function(store, object) { //### TODO options, not positional params
    if (object) {
      store.loadItem({
        item: object,
        scope: this,
        onItem: function(loadedObject) {
          this.forProperties(function(prop, widget) {
            widget.attr('value', store.getValue(loadedObject, prop));
          });
          this.onPopulated(loadedObject);
        }
      });
    } else {
      this.forProperties(function(prop, widget) {
        widget.setValue(null);
      });
      this.onCleared();
    }
    this.object = object;
    this.store = store;
  },

  save: function() {
    if (this.object) {
      this.forProperties(function(prop, widget) {
        var value = widget.attr('value');
        if (dojo.config.isDebug) {
          console.debug('Setting value for ', prop, ' to ', value);
        }
        this.store.setValue(this.object, prop, value);
      });
      //### TODO what if more than one item is currently being edited?
      this.store.save({
        onComplete: this.onSaved,
        onError: this.onError,
        scope: this
      });
    }
  },

  isModified: function() {
    if (!this.object) {
      return false;
    }
    var modified = false;
    this.forProperties(function(prop, widget) {
      if (!modified || dojo.config.isDebug) {
        var widgetModified;
        var orig = this.store.getValue(this.object, prop) || '';
        var cur = widget.attr('value') || '';
        if (orig instanceof Date || cur instanceof Date) {
          widgetModified = (dojo.date.compare(orig, cur) !== 0);
        } else {
          widgetModified = orig.toString() != cur.toString();
        }
        if (widgetModified && dojo.config.isDebug) {
          console.debug('modified widget: ', widget, "\noriginal value: ", orig, "\ncurrent value: ", cur);
        }
        modified = modified || widgetModified;
      }
    });
    return modified;
  },

  onPopulated: function(item) {
    // tags:
    //   callback
  },
  onCleared: function() {
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