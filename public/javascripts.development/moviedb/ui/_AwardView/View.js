dojo.provide('moviedb.ui._AwardView.View');
dojo.require('dojo.i18n');
dojo.require('moviedb.ui._AwardView.AwardingsList');
dojo.requireLocalization('moviedb', 'awards');

dojo.declare('moviedb.ui._AwardView.View', null, {
  baseClass: 'moviedbAwardView',
  iconClass: 'smallIcon awardIcon',
  templatePath: dojo.moduleUrl('moviedb', 'ui/_AwardView/AwardView.html'),

  postMixInProperties: function() {
    var _nlsResources = dojo.i18n.getLocalization('moviedb', 'awards');
    dojo.mixin(this, _nlsResources);
    this.inherited(arguments);
  },

  onGroupAdded: function(titlePane, group) {
  },
  onShowGroup: function(titlePane, group) {
  },

  _renderView: function(groups) {
    dojo.empty(this.listNode);
    dojo.forEach(groups, dojo.hitch(this, function(group) {
      var groupItem = dojo.create('li');
      var titlePane = new dijit.TitlePane({
        title: dojo.string.substitute(this.groupTitle, {group: group.name}),
        open: false
      });
      titlePane.placeAt(groupItem);
      dojo.place(groupItem, this.listNode);

      dojo.connect(titlePane, 'onShow', dojo.hitch(this, 'onShowGroup', titlePane, group));
      this.onGroupAdded(titlePane, group);
    }));
  },

  _renderGroup: function(titlePane, group) {
    var listNode = dojo.create('div');
    titlePane.attr('content', listNode);
    this._makeGroupListWidget(group.awardings, listNode);
  }
});
