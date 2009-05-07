dojo.provide('moviedb.ui._AwardView.Controller');
dojo.require('plugd.ancestor');
dojo.require('aiki._base');
dojo.require('aiki.Standby');
dojo.require('moviedb.ui._AwardView.GroupManager');

dojo.declare('moviedb.ui._AwardView.Controller', null, {

  constructor: function(store, object, view) {
    this.store = store;
    this.object = object;
    this.view = view;

    this._whenReady        = new dojo.Deferred();
    this._yearGranularity  = parseInt(view.yearGranularity) || 10;
    this._startYearGroup   = this._yearGroup(parseInt(view.startYear));
    this._endYearGroup     = this._yearGroup((new Date()).getYear() + 1900);
    this._showAwardingYear = this._yearGranularity > 1;
    this._showAwardName    = view.showAwardName;

    this._groupManager = new moviedb.ui._AwardView.GroupManager(
      dojo.hitch(this, '_awardingDomID'));

    dojo.connect(view, 'onGroupAdded', this._groupManager, 'add');
    dojo.connect(view, 'onShowGroup', this, 'loadGroup');
    dojo.connect(view, 'onClick', this, '_publishSelect');
  },

  loadGroup: function(group, groupNode) {
    console.debug('**** SHOW GROUP ', group); //### REMOVE
    //### TODO push into AwardingsList
    if (group.awardings) {
      return;
    }
    var standby = new aiki.Standby(groupNode.parentNode);

    //### TODO don't break the abstraction, let store handle queried loading somehow
    this._withLoadedObject(function(object) {
      var query = dojo.string.substitute("[?year>=${firstYear}][?year<=${lastYear}]", {
        firstYear: group.firstYear, lastYear: group.lastYear
      });
      var ref = object.awardings.$ref.replace(/^\/awards\//, ''); //###
      this.store.fetch({
        queryStr: ref + '?' + query + '[\\year]', //###
        onComplete: dojo.hitch(this, function(items) {
          group.awardings = items;
          this.view._renderGroup(group, groupNode);
          standby.stop();
        }),
        onError: function(err) {
          console.error('AwardView.Controller.loadGroup ', err); //###
        }
      });
    });
  },

  _withLoadedObject: function(callback) {
    this.store.loadItem({
      item: this.object,
      onItem: dojo.hitch(this, function(loadedObject) {
        this.object = loadedObject;
        callback.call(this, this.object);
      })
    });
  },

  render: function() {
    var gran = this._yearGranularity;
    var groups = [];
    for (var y = this._endYearGroup; y >= this._startYearGroup; y -= gran) {
      groups.push({ name: y.toString(), firstYear: y, lastYear: (y + gran - 1) });
    }
    this.view._renderView(groups);
    this._whenReady.callback(this.view);
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

  _yearGroup: function(year) {
    return Math.floor(year / this._yearGranularity) * this._yearGranularity;
  },

  _awardingDomID: function(awarding) {
    var baseId = this._baseDomId = (this._baseDomId || ('award_' + this._cleanId(this.store, this.object)));
    return awarding ? (baseId + '_' + this._cleanId(this.store, awarding)) : baseId;
  },

  _cleanId: function(store, object) {
    return store.getIdentity(object).toString().replace(/\W+/g, '_');
  }
});
