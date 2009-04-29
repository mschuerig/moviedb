dojo.provide('moviedb.AwardView');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');
dojo.require('dojo.i18n');
dojo.require('dojox.dtl._Templated');
dojo.require('dojox.dtl.contrib.data');
dojo.require('plugd.ancestor');
dojo.require('aiki._base');
dojo.require('aiki.dtl.dom');
dojo.requireLocalization('moviedb', 'awards');

(function() {

function awardingsListContains(awardings, theAwarding) {
  if (!theAwarding) {
    return false;
  }
  return dojo.some(awardings, function(it) { return it.id == theAwarding.id; });
}

function cleanId(store, object) {
  return store.getIdentity(object).toString().replace(/\W+/g, '_');
}

dojo.declare('moviedb.AwardView', [dijit._Widget, dijit._Templated], {
  store: null,
  object: null,
  showAwardName: false,
  yearGranularity: 10,

  baseClass: 'moviedbAwardView',
  iconClass: 'smallIcon awardIcon',
  awardingsListWidget: 'moviedb._AwardingsList',
  templatePath: dojo.moduleUrl('moviedb', 'templates/AwardView.html'),

  getFeatures: function(){
    return {
      "moviedb.api.View": true
    };
  },

  postMixInProperties: function() {
    var _nlsResources = dojo.i18n.getLocalization('moviedb', 'awards');
    dojo.mixin(this, _nlsResources);
    this.inherited(arguments);
    this._groupListWidget = dojo.getObject(this.awardingsListWidget);
    this.yearGranularity = parseInt(this.yearGranularity) || 10;
    this._showAwardingYear = this.yearGranularity > 1;
  },

  postCreate: function() {
    this._groupManager = new moviedb._AwardGroupManager(
      dojo.hitch(this, '_awardingDomID'));

    //### FIXME hack alert, this should be handled by loadItem
    this.store.fetchItemByIdentity({
      identity: this.object.$ref || this.object.__id,
      onItem: dojo.hitch(this, function(loadedObject) {
        this.object = loadedObject;
        this.awardings = this.store.getValues(this.object.awardings, 'items');
        this._renderView();
        dojo.connect(this, 'onClick', this, '_publishSelect');
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
  },

  getTitle: function() {
    return this.object.name;
  },

  showAwarding: function(awarding) {
    this._groupManager.showAwarding(awarding);
  },

  _renderView: function() {
    dojo.empty(this.listNode);

    var groups = aiki.groupBy(this.awardings, this._makeGrouper(this.yearGranularity));
    var keys = groups.keys.sort(function(a, b) { return b - a; });

    for (var i = 0, l = keys.length; i < l; i++) {
      var awardings = groups.groups[keys[i]].sort(
        function(a, b) { return b.year - a.year; });
      var titlePane = this._renderGroup(i, keys[i], awardings);
      this._groupManager.add(titlePane, awardings);
    }
  },

  _renderGroup: function(num, name, awardings) {
    var groupIsOpen = false; /*= hiliteAwarding ?
      awardingsListContains(awardings, hiliteAwarding)
      : false; //### FIXME (num == 0);*/

    var perGroupList = new this._groupListWidget({
      items: awardings,
      store: this.store,
      baseId: this._awardingDomID(),
      showAwardName: this.showAwardName,
      showAwardingYear: this._showAwardingYear
    });

    var groupTitle = new dijit.TitlePane({
      title: dojo.string.substitute(this.groupTitle, {group: name}),
      content: perGroupList,
      open: groupIsOpen
    });

    var groupItem = dojo.create('li');
    groupTitle.placeAt(groupItem);
    dojo.place(groupItem, this.listNode);

    return groupTitle;
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

  _awardingDomID: function(awarding) {
    var baseId = this._baseDomId = (this._baseDomId || ('award_' + cleanId(this.store, this.object)));
    return awarding ? (baseId + '_' + cleanId(this.store, awarding)) : baseId;
  },

  _makeGrouper: function(granularity) {
    return function(item) { return Math.floor(item.year / granularity) * granularity; };
  }
});

dojo.declare('moviedb._AwardGroupManager', null, {
  hiliteDuration: 2000,
  _groups: [],

  constructor: function(domIdMaker) {
    this._domId = domIdMaker;
  },

  add: function(titlePane, awardings) {
    this._groups.push({ titlePane: titlePane, awardings: awardings });
  },

  showAwarding: function(awarding) {
    console.debug('**** SHOW AWARDING: ', awarding); //###
    var itsGroup = aiki.find(this._groups,
      function(group) { return awardingsListContains(group.awardings, awarding); });
    if (itsGroup) {
      if (!itsGroup.titlePane.open) {
        itsGroup.titlePane.toggle();
      }
      var awardingNode = dojo.byId(this._domId(awarding));
      console.debug('** dom id: ', this._domId(awarding)); //###
      dijit.scrollIntoView(awardingNode);

      dojo.animateProperty({
        node: awardingNode,
        duration: this.hiliteDuration,
        properties: {
          backgroundColor: {
            start: '#FFFF00',
            end:   '#FFFFFF'
          }
        }
      }).play();
    }
  }
});

dojo.declare('moviedb._AwardingsList', [dijit._Widget, dojox.dtl._Templated], {
  store: null,
  items: null,
  baseId: null,
  templatePath: dojo.moduleUrl("moviedb", "templates/_AwardingsList.html")
});

})();
