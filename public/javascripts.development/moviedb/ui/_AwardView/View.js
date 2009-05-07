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

  onGroupAdded: function(group, titlePane) {
  },
  onShowGroup: function(group, groupNode) {
  },

  _renderView: function(groups) {
    dojo.empty(this.listNode);
    dojo.forEach(groups, dojo.hitch(this, function(group) {
      var groupContentNode = dojo.create('div');
      var groupItem = dojo.create('li');
      var titlePane = new dijit.TitlePane({
        title: dojo.string.substitute(this.groupTitle, {group: group.name}),
        content: groupContentNode,
        open: false
      });
      titlePane.placeAt(groupItem);
      dojo.place(groupItem, this.listNode);

      dojo.connect(titlePane, 'onShow', dojo.hitch(this, 'onShowGroup', group, groupContentNode));
      this.onGroupAdded(group, titlePane);
    }));
  },

  _renderGroup: function(group, groupNode) {
    this._makeGroupListWidget(group.awardings, groupNode);
  }
});
