dojo.provide('moviedb.ui._AwardView.View');
dojo.require('dojo.i18n');
dojo.require('moviedb.ui._AwardView.AwardingsList');
dojo.requireLocalization('moviedb', 'awards');

(function() {

//### TODO extract
function cleanId(store, object) {
  return store.getIdentity(object).toString().replace(/\W+/g, '_');
}

dojo.declare('moviedb.ui._AwardView.View', null, {
  baseClass: 'moviedbAwardView',
  iconClass: 'smallIcon awardIcon',
  awardingsListWidget: 'moviedb.ui._AwardView.AwardingsList',
  templatePath: dojo.moduleUrl('moviedb', 'ui/_AwardView/AwardView.html'),

  postMixInProperties: function() {
    var _nlsResources = dojo.i18n.getLocalization('moviedb', 'awards');
    dojo.mixin(this, _nlsResources);
    this.inherited(arguments);
    this._awardingsListWidget = dojo.getObject(this.awardingsListWidget);
    this.yearGranularity = parseInt(this.yearGranularity) || 10;
    this._showAwardingYear = this.yearGranularity > 1;
  },

  _renderView: function(awardings) {
    dojo.empty(this.listNode);
    for (var i = 0, l = awardings.length; i < l; i++) {
      var group = awardings[i];
      var groupItem = dojo.create('li');
      var titlePane = this._renderGroup(i, group.name, group.awardings);
      titlePane.placeAt(groupItem);
      dojo.place(groupItem, this.listNode);

//### FIXME      this._groupManager.add(titlePane, awardings);
    }
  },

  _renderGroup: function(num, name, awardings) {
    console.debug('** RENDER GROUP: ', num, name, awardings.length, awardings); //### REMOVE
    var contentNode = dojo.create('div');

    var groupTitle = new dijit.TitlePane({
      title: dojo.string.substitute(this.groupTitle, {group: name}),
      open: false,
      content: contentNode
    });

    var perGroupList = new this._awardingsListWidget({
      items: awardings,
      store: this.store,
      baseId: this._awardingDomID(),
      showAwardName: this.showAwardName,
      showAwardingYear: this._showAwardingYear
    }, contentNode);

    return groupTitle;
  },

  _awardingDomID: function(awarding) {
    var baseId = this._baseDomId = (this._baseDomId || ('award_' + cleanId(this.store, this.object)));
    return awarding ? (baseId + '_' + cleanId(this.store, awarding)) : baseId;
  }
});

})();
