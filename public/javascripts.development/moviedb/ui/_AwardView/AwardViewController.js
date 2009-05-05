dojo.provide('moviedb.ui._AwardView.AwardViewController');
dojo.require('plugd.ancestor');
dojo.require('aiki._base');

dojo.declare('moviedb.ui._AwardView.AwardViewController', null, {
  constructor: function(store, object, view) {
    this.store = store;
    this.object = object;
    this.view = view;

    this._groupManager = new moviedb.ui._AwardView.AwardGroupManager(
      dojo.hitch(this.view, '_awardingDomID'));
  },

  load: function() {
      //### FIXME hack alert, this should be handled by loadItem
    var loaded = new dojo.Deferred();

    this.store.fetchItemByIdentity({
      identity: this.object.$ref || this.object.__id,
      onItem: dojo.hitch(this, function(loadedObject) {
        console.debug('*** ON ITEM'); //### REMOVE
        this.object = loadedObject;
        var awardings = this.store.getValues(this.object.awardings, 'items');
        loaded.callback(this._groupAwardings(awardings));
        dojo.connect(this.view, 'onClick', this, '_publishSelect');
      })
    });
/*
    this.store.loadItem({
      item: this.object,
      onItem: dojo.hitch(this, function(loadedObject) {
        this.object = loadedObject;
        this.awardings = this.store.getValues(this.object.awardings, 'items');
        this._renderView();
        dojo.connect(this, 'onClick', this, '_publishSelect');
      })
    });
*/
    return loaded;
  },

  getFeatures: function(){
    return {
      "aiki.api.View": true
    };
  },

  getTitle: function() {
    return this.object.name;
  },

  openTopGroup: function() {
    this._groupManager.openTopGroup();
  },

  showAwarding: function(awarding) {
    this._groupManager.showAwarding(awarding);
  },

  _groupAwardings: function(awardings) {
    var groups = aiki.groupBy(awardings, this._makeGrouper(this.view.yearGranularity));
    var keys = groups.keys.sort(function(a, b) { return b - a; });
    var groupedAwardings = [];
    for (var i = 0, l = keys.length; i < l; i++) {
      var sortedAwardings = groups.groups[keys[i]].sort(
        function(a, b) { return b.year - a.year; });
      groupedAwardings.push({ name: keys[i], awardings: sortedAwardings });
    }
    return groupedAwardings;
  },

  _publishSelect: function(event) {
    if (this._tryPublish(event, 'people', 'person.selected') ||
        this._tryPublish(event, 'movies', 'movie.selected')) {
      dojo.stopEvent(event);
    }
  },

  _tryPublish: function(event, kind, topic) {
    var link = dojo.ancestor(event.target, '.awarding .' + kind +  ' .list a', this.domNode);
    if (link && link.pathname) {
      dojo.publish(topic || (kind + '.selected'), [link.pathname + link.search]);
      return true;
    }
    return false;
  },

  _makeGrouper: function(granularity) {
    return function(item) { return Math.floor(item.year / granularity) * granularity; };
  }
});
