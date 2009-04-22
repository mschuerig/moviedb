dojo.provide('moviedb.AwardView');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');
dojo.require('dojox.dtl._Templated');

dojo.declare('moviedb.AwardView', [dijit._Widget, dijit._Templated], {
  store: null,
  object: null,

  baseClass: 'moviedbAwardView',
  awardingWidget: 'moviedb._AwardingView',
  templatePath: dojo.moduleUrl('moviedb', 'templates/AwardView.html'),

  getFeatures: function(){
    return {
      "moviedb.api.View": true
    };
  },

  startup: function() {
    this.awardings = this.store.getValues(this.object.awardings, 'items');
    this._updateView();
    dojo.connect(this, 'onClick', this, '_publishSelect');
  },
  getTitle: function() {
    return this.object.name;
  },
  _updateView: function() {
    dojo.empty(this.listNode);

    var decades = dojo.groupBy(this.awardings,
      function(item) { return Math.floor(item.year / 10) * 10; } );
    var keys = decades.keys.sort(function(a, b) { return b - a; });

    var itemWidget = dojo.getObject(this.awardingWidget);

    for (var i = 0, l = keys.length, first = true; i < l; i++) {
      var awardings = decades.groups[keys[i]].sort(
        function(a, b) { return b.year - a.year; });
      var perDecadeList = dojo.create('ul', {className: 'decade'});
      awardings.forEach(function(item) {
        var li = dojo.create('li');
        var aw = new itemWidget({awarding: item});
        aw.placeAt(li);
        dojo.place(li, perDecadeList);
      });
      var decadeTitle = new dijit.TitlePane({
        title: keys[i] + 's', //### TODO i18n
        content: perDecadeList,
        open: first
      });
      var decadeItem = dojo.create('li');
      decadeTitle.placeAt(decadeItem);
      dojo.place(decadeItem, this.listNode);
      first = false;
    }
  },
  _publishSelect: function(event) {
    dojo.stopEvent(event); //### REMOVE
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
  }
});

dojo.declare('moviedb._AwardingView', [dijit._Widget, dojox.dtl._Templated], {
  awarding: null,
  templatePath: dojo.moduleUrl("moviedb", "templates/_Awarding.html")
});
