dojo.provide('aiki.form._DataMixin');

dojo.declare('aiki.form._DataMixin', null, {
  object: null,
  store: null,

  populate: function(store, object) {
    if (object) {
      var self = this;
      store.loadItem({ item: object,
        onItem: function(loadedObject) {
          self.forProperties(function(prop, widget) {
            widget.attr('value', store.getValue(loadedObject, prop));
          });
        }
      });
    } else {
      this.forProperties(function(prop, widget) {
        widget.setValue(null);
      });
    }
    this.object = object;
    this.store = store;
    this.onPopulated();
  },

  save: function() {
    if (this.object) {
      this.forProperties(function(prop, widget) {
        this.store.setValue(this.object, prop, widget.attr('value'));
      });
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

  onPopulated: function() {
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
