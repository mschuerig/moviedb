dojo.provide('moviedb.ui.AwardView');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');
dojo.require('dojo.i18n');
dojo.require('dojox.dtl._DomTemplated');
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

//### TODO extract
function cleanId(store, object) {
  return store.getIdentity(object).toString().replace(/\W+/g, '_');
}

//### TODO extract
function hilite(node, duration) {
  dojo.animateProperty({
    node: node,
    duration: duration || 2000,
    properties: {
      backgroundColor: {
        start: '#FFFF00',
        end:   '#FFFFFF'
      }
    }
  }).play();
}

dojo.declare('moviedb.ui.AwardView', [dijit._Widget, dijit._Templated], {
  store: null,
  object: null,
  showAwardName: false,
  yearGranularity: 10,

  baseClass: 'moviedbAwardView',
  iconClass: 'smallIcon awardIcon',
  awardingsListWidget: 'moviedb.ui._AwardingsList',
  templatePath: dojo.moduleUrl('moviedb', 'ui/_AwardView/AwardView.html'),

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

  openTopGroup: function() {
    this._groupManager.openTopGroup();
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
    var listNode = dojo.create('div');
    var groupTitle = new dijit.TitlePane({
      title: dojo.string.substitute(this.groupTitle, {group: name}),
      open: false,
      content: listNode
    });

    var perGroupList = new this._groupListWidget({
      items: awardings,
      store: this.store,
      baseId: this._awardingDomID(),
      showAwardName: this.showAwardName,
      showAwardingYear: this._showAwardingYear
    }, listNode);

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

  openTopGroup: function() {
    var topGroup = this._groups[0];
    if (topGroup) {
      this._openGroup(topGroup);
      dijit.scrollIntoView(topGroup.titlePane.domNode);
    }
  },

  showAwarding: function(awarding) {
    var itsGroup = aiki.find(this._groups,
      function(group) { return awardingsListContains(group.awardings, awarding); });
    if (itsGroup) {
      this._openGroup(itsGroup);
      var awardingNode = dojo.byId(this._domId(awarding));
      dijit.scrollIntoView(awardingNode);
      hilite(awardingNode, this.hiliteDuration);
    }
  },

  _openGroup: function(group) {
    if (!group.titlePane.open) {
      group.titlePane.toggle();
    }
  }
});

dojo.declare('moviedb.ui._AwardingsList', [dijit._Widget, dojox.dtl._DomTemplated], {
  store: null,
  items: null,
  baseId: null,
  templatePath: dojo.moduleUrl("moviedb", "ui/_AwardView/_AwardingsList.html")
});

})();
