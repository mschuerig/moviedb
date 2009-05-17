dojo.provide('moviedb.ui._AwardView.View');
dojo.require('dojo.i18n');
dojo.requireLocalization('moviedb', 'awards');

dojo.declare('moviedb.ui._AwardView.View', null, {
  baseClass: 'moviedbAwardView',
  iconClass: 'smallIcon awardIcon',
  templatePath: dojo.moduleUrl('moviedb', 'ui/_AwardView/AwardView.html'),

  postMixInProperties: function() {
    this._nls = dojo.i18n.getLocalization('moviedb', 'awards');
    this.inherited(arguments);
  },

  render: function(groups) {
    dojo.forEach(groups, function(group) {
      var groupItem = dojo.create('li');
      dojo.place(groupItem, this.listNode);
      group.renderAt(groupItem);
    }, this);
  }
});
