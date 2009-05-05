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

  onGroupAdded: function(titlePane, awardings) {
  },

  _renderView: function(awardings) {
    dojo.empty(this.listNode);
    for (var i = 0, l = awardings.length; i < l; i++) {
      var group = awardings[i];
      var groupItem = dojo.create('li');
      var titlePane = this._renderGroup(i, group.name, group.awardings);
      titlePane.placeAt(groupItem);
      dojo.place(groupItem, this.listNode);

      this.onGroupAdded(titlePane, group.awardings);
    }
  },

  _renderGroup: function(num, name, awardings) {
    var contentNode = dojo.create('div');

    var groupTitle = new dijit.TitlePane({
      title: dojo.string.substitute(this.groupTitle, {group: name}),
      open: false,
      content: contentNode
    });

    this._makeGroupListWidget(awardings, contentNode);

    return groupTitle;
  }
});
