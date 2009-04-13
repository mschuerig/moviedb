
dojo.provide('moviedb.Form');

dojo.declare('moviedb.Form', dijit.form.Form, {
  //### TODO
  // - derive appropriate widgets and validations from a json schema
  // - propertiesMap: convention|explicit map|mapping function
  movie: null,
  propertiesMap: {
    'movie_title': 'title',
    'movie_release_date': 'releaseDate',
    'movie_summary': 'summary'
  },
  constructor: function() {
    console.log('*** FORM ctor: ', arguments);
  },
  populate: function(store, movie) {
    if (movie) {
      var propertiesMap = this.propertiesMap;
      store.loadItem({ item: movie,
        onItem: function(loadedMovie) {
          for (var prop in propertiesMap) {
            var value = store.getValue(loadedMovie, propertiesMap[prop]);
            dijit.byId(prop).setValue(value);
          }
        }
      });
    } else {
      for (var prop in this.propertiesMap) {
        dijit.byId(prop).setValue(null);
      }
    }
    this._lastChanged = false;
    this._originalState = dojo.formToJson(this.domNode);
    this.movie = movie;
  },
  isChanged: function() {
    if (!this.movie) return false;
    return this._areFormValuesEqual(
      this._originalState,
      dojo.formToObject(this.domNode));
  },
  connectChildren: function() {
    this.inherited(arguments);
    var self = this;
      var conns = this._changeConnections;
    dojo.forEach(this.getDescendants(), function(widget) {
      conns.push(self.connect(widget, 'onChange',
        dojo.hitch(self, '_checkForChange', widget)));
    });
  },
  _checkForChange: function(widget) {
    if (!this.movie) return;
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
  _areFormValuesEqual: function(a, b) {
    for (var x in a) {
	  if (a[x] !== b[x]) {
		return true;
	  }
	};
	for (var x in b) {
	  if (b[x] !== a[x]) {
		return true;
	  }
	}
    return true;
  },
  onChange: function() {
    console.log("*** ON CHANGE");
  },
  onRevert: function() {
    console.log("*** ON REVERT");
  }
});
