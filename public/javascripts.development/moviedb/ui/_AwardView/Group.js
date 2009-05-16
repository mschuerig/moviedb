dojo.provide('moviedb.ui._AwardView.Group');
dojo.require('dijit.TitlePane');
dojo.require('aiki.Standby');

dojo.declare('moviedb.ui._AwardView.Group', null, {
  constructor: function(presenter, title, firstYear, lastYear) {
    this.presenter = presenter;
    this.title = title;
    this.firstYear = firstYear;
    this.lastYear = lastYear;
  },

  renderAt: function(node) {
    var listNode = this.listNode = dojo.create('div');
    var titlePane = this.titlePane = new dijit.TitlePane({
      title: this.title, //### dojo.string.substitute(this.groupTitle, {group: this.name}),
      content: listNode,
      open: false
    });
    titlePane.placeAt(node);
    dojo.connect(titlePane, 'onShow', this, '_onOpened');
  },

  show: function(awarding) {
    this._hilitedAwarding = awarding;
    dijit.scrollIntoView(this.titlePane.domNode);
    if (this.titlePane.open) {
      this._hiliteAwarding();
    } else {
      this.titlePane.toggle();
    }
  },

  _onOpened: function() {
    if (!this.awardings) {
      var standby = new aiki.Standby(this.titlePane.domNode);
      this._withLoadedAwardings(function() {
        this._renderList();
        standby.stop();
        this._hiliteAwarding();
      });
    } else {
      this._hiliteAwarding();
    }
  },

  _withLoadedAwardings: function(callback) {
    this.presenter.loadAwardings(this, dojo.hitch(this, callback));
  },

  _renderList: function() {
    this.presenter.makeAwardingList(this.awardings, this.listNode);
  },

  _hiliteAwarding: function() {
    if (this._hilitedAwarding) {
      var awardingNode = dojo.byId(this.presenter.domId(this._hilitedAwarding));
      dijit.scrollIntoView(awardingNode);
      aiki.hilite(awardingNode, this.presenter.hiliteDuration);
      this._hilitedAwarding = null;
    }
  }
});
