dojo.provide('moviedb.AwardView');
dojo.require('dijit.layout.ContentPane');
dojo.require('dijit._Templated');
dojo.require('dojox.dtl._Templated');

dojo.declare('moviedb.AwardView', [dijit.layout.ContentPane, dijit._Templated], {
  store: null,
  object: null,

  baseClass: 'moviedbAwardView',
  awardingWidget: 'moviedb._AwardingView',

  templatePath: dojo.moduleUrl("moviedb", "templates/AwardView.html"),

  startup: function() {
    console.log('*** LOADING awardings for: ', this.object); //### REMOVE
    this.awardings = this.store.getValues(this.object.awardings, 'items');
    console.log('** AWARDINGS: ', this.awardings);
    this._updateView();
    dojo.connect(this, 'onClick', this, '_publishSelect');
  },
  getTitle: function() {
    return this.object.name;
  },
  isModified: function() {
    return false;
  },
  _updateView: function() {
    dojo.empty(this.listNode);

    var decades = dojo.groupBy(this.awardings,
      function(item) {
        v = Math.floor(item.year / 10) * 10;
        if (isNaN(v)) {
          console.error('year NaN: ', item);
        }
        return v;
      } );
    var keys = decades.keys.sort(function(a, b) { return b - a; });

    var itemWidget = dojo.getObject(this.awardingWidget);

    for (var i = 0, l = keys.length, first = true; i < l; i++) {
      var awardings = decades.groups[keys[i]].sort(
        function(a, b) { return b.year - a.year; });
      var perDecadeList = dojo.create('ul');
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
    console.log('*** SELECTED: ', arguments);
    var link = event.target; //### TODO find enclosing link
    dojo.stopEvent(event);
  }
});

dojo.declare('moviedb._AwardingView', [dijit._Widget, dojox.dtl._Templated], {
  awarding: null,
  templatePath: dojo.moduleUrl("moviedb", "templates/_Awarding.html")
});
