dojo.provide('moviedb.AwardView');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');
dojo.require('dojo.i18n');
dojo.require('dojox.dtl._Templated');
dojo.require('dojox.dtl.contrib.data');
dojo.require('plugd.ancestor');
dojo.require('aiki._base');
dojo.requireLocalization('moviedb', 'awards');

dojo.declare('moviedb.AwardView', [dijit._Widget, dijit._Templated], {
  store: null,
  object: null,
  hiliteAwarding: null,
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

  _renderView: function() {
    dojo.empty(this.listNode);

    var groups = aiki.groupBy(this.awardings, this._makeGrouper(this.yearGranularity));
    var keys = groups.keys.sort(function(a, b) { return b - a; });

    for (var i = 0, l = keys.length; i < l; i++) {
      var awardings = groups.groups[keys[i]].sort(
        function(a, b) { return b.year - a.year; });
      this._renderGroup(i, keys[i], awardings);
    }
  },

  _renderGroup: function(num, name, awardings) {
    {
      var hiliteAwarding = this.hiliteAwarding;
      var groupIsOpen = hiliteAwarding ?
        dojo.some(awardings, function(it) { return it.id == hiliteAwarding.id; })
        : false; //### FIXME (num == 0);

      var perGroupList = new this._groupListWidget({
        items: awardings,
        store: this.store,
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
    }
  },

  _setHintAttr: function(hint) {
    //### TODO
  },

  _showAwarding: function(awarding) {

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

dojo.declare('moviedb._AwardingsList', [dijit._Widget, dojox.dtl._Templated], {
  store: null,
  items: null,
  templatePath: dojo.moduleUrl("moviedb", "templates/_AwardingsList.html")
});
