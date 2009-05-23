dojo.provide('moviedb.ui.AwardView');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');
dojo.require('plugd.ancestor');
dojo.require('moviedb.Dispatcher');
dojo.require('moviedb.ui._AwardView.AwardingsList');
dojo.require('moviedb.ui._AwardView.Group');
dojo.require('moviedb.ui._AwardView.View');
dojo.require('aiki.api.View');

dojo.declare('moviedb.ui.AwardView',
  [dijit._Widget, dijit._Templated, moviedb.ui._AwardView.View], {

  _isReady: false,

  showAwardName: false,
  startYear: 1970,
  endYear: (new Date().getYear() + 1900),
  yearGranularity: 10,
  hiliteDuration: 2000,

  store: null,
  object: null,

  getFeatures: function(){
    return {
      "aiki.api.View": true
    };
  },

  postMixInProperties: function() {
    this._startYearGroup   = this._yearGroup(this.startYear);
    this._endYearGroup     = this._yearGroup(this.endYear);
    this._showAwardingYear = this.yearGranularity > 1;

    this.inherited(arguments);

    this._whenReady        = new dojo.Deferred();
  },

  buildRendering: function() {
    this.inherited(arguments);

    this.presenter = {
      loadAwardings:    dojo.hitch(this, '_loadAwardings'),
      makeAwardingList: dojo.hitch(this, '_makeAwardingList'),
      hiliteDuration:   this.hiliteDuration,
      domId:            dojo.hitch(this, '_awardingDomID')
    };

    var groups = this._groups = this._makeGroups(this.presenter);

    this.render(groups);
    
    this._isReady = true;
    this._whenReady.callback(this);
  },

  postCreate: function() {
    this._dispatcher = new moviedb.Dispatcher(this.domNode, 
      { event: 'click', path: '.person a', topic: 'person.selected' },
      { event: 'click', path: '.movie a',  topic: 'movie.selected' }
    );
  },

  _makeGroups: function(presenter) {
    var gran = this.yearGranularity;
    var groups = [];
    for (var y = this._endYearGroup; y >= this._startYearGroup; y -= gran) {
      groups.push(new moviedb.ui._AwardView.Group(presenter, y.toString(), y, (y + gran - 1)));
    }
    return groups;
  },

  _makeAwardingList: function(awardings, node) {
    new moviedb.ui._AwardView.AwardingsList({
      store: this.store,
      items: awardings,
      baseId: this._awardingDomID(),
      showAwardName: this.showAwardName,
      showAwardingYear: this._showAwardingYear
    }, node);
  },

  _loadAwardings: function(group, callback) {
    var query = dojo.string.substitute("[?year>=${firstYear}][?year<=${lastYear}]", {
      firstYear: group.firstYear, lastYear: group.lastYear
    });
    var ref = this.object.awardings.$ref.replace(/^\/awards\//, ''); //###
    this.store.fetch({
      queryStr: ref + '?' + query + '[\\year]', //###
      onComplete: dojo.hitch(this, function(items) {
        group.awardings = items;
        callback();
      }),
      onError: function(err) {
        console.error('AwardView loadAwardings ', err); //###
      }
    });
  },

  whenReady: function(/* Function? */callback) {
    if (callback) {
      this._whenReady.addCallback(callback);
    }
    return this._whenReady;
  },

  isReady: function() {
    return this._isReady;
  },

  getTitle: function() {
    return this.object.name;
  },

  openTopGroup: function() {
    console.debug('*** open top group');
    var topGroup = this._groups[0];
    if (topGroup) {
      topGroup.show();
    }
  },

  showAwarding: function(awarding) {
    console.debug('*** SHOW AWARDING: ', awarding); //###
    var year = awarding.year;
    var itsGroup = aiki.find(this._groups, function(group) {
      return group.firstYear <= year && year <= group.lastYear;
    });
    console.debug('** group: ', itsGroup); //###
    if (itsGroup) {
      itsGroup.show(awarding);
    }
  },

  _yearGroup: function(year) {
    return Math.floor(year / this.yearGranularity) * this.yearGranularity;
  },

  _awardingDomID: function(awarding) {
    var baseId = this._baseDomId = (this._baseDomId || ('award_' + this._cleanId(this.store, this.object)));
    return awarding ? (baseId + this._cleanId(this.store, awarding)) : baseId;
  },

  _cleanId: function(store, object) {
    return store.getIdentity(object).toString().replace(/\W+/g, '_');
  },

});
