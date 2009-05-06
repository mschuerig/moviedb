dojo.provide('moviedb.ui._AwardView.Controller');
dojo.require('plugd.ancestor');
dojo.require('aiki._base');
dojo.require('moviedb.ui._AwardView.GroupManager');

dojo.declare('moviedb.ui._AwardView.Controller', null, {

  constructor: function(store, object, view) {
    this.store = store;
    this.object = object;
    this.view = view;

    this._whenReady = new dojo.Deferred();
    this._yearGranularity = parseInt(view.yearGranularity) || 10;
    this._showAwardingYear = this.yearGranularity > 1;
    this._showAwardName = view.showAwardName;

    this._groupManager = new moviedb.ui._AwardView.GroupManager(
      dojo.hitch(this, '_awardingDomID'));

    dojo.connect(view, 'onGroupAdded', this._groupManager, 'add');
    dojo.connect(view, 'onClick', this, '_publishSelect');
  },

  load: function() {

    //### TODO cleanup
    this.store.loadItem({
      item: this.object,
      onItem: dojo.hitch(this, function(loadedObject) {
        this.object = loadedObject;
        var awardings = this.store.getValue(this.object, 'awardings');
        this.store.loadItem({
          item: awardings,
          onItem: dojo.hitch(this, function(loadedAwardings) {
            this.view._renderView(this._groupAwardings(loadedAwardings));
            this._whenReady.callback(this.view);
          })
        });
      })
    });
  },

  whenReady: function(/* Function? */callback) {
    if (callback) {
      this._whenReady.addCallback(callback);
    }
    return this._whenReady;
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
    var groups = aiki.groupBy(awardings, this._makeGrouper(this._yearGranularity));
    var keys = groups.keys.sort(function(a, b) { return b - a; });
    var groupedAwardings = [];
    for (var i = 0, l = keys.length; i < l; i++) {
      var sortedAwardings = groups.groups[keys[i]].sort(
        function(a, b) { return b.year - a.year; });
      groupedAwardings.push({ name: keys[i], awardings: sortedAwardings });
    }
    return groupedAwardings;
  },

  _makeGroupListWidget: function(widgetType, awardings, node) {
    return new widgetType({
      items: awardings,
      store: this.store,
      baseId: this._awardingDomID(),
      showAwardName: this._showAwardName,
      showAwardingYear: this._showAwardingYear
    }, node);
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
  },

  _awardingDomID: function(awarding) {
    var baseId = this._baseDomId = (this._baseDomId || ('award_' + this._cleanId(this.store, this.object)));
    return awarding ? (baseId + '_' + this._cleanId(this.store, awarding)) : baseId;
  },

  _cleanId: function(store, object) {
    return store.getIdentity(object).toString().replace(/\W+/g, '_');
  }
});
