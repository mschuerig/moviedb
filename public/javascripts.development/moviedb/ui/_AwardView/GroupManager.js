dojo.provide('moviedb.ui._AwardView.GroupManager');

(function() {

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

dojo.declare('moviedb.ui._AwardView.GroupManager', null, {
  hiliteDuration: 2000,

  constructor: function(domIdMaker) {
    this._domId = domIdMaker;
    this._groups = [];
  },

  add: function(group) {
    this._groups.push(group);
  },

  openTopGroup: function() {
    var topGroup = this._groups[0];
    if (topGroup) {
      this._openGroup(topGroup);
      dijit.scrollIntoView(topGroup.titlePane.domNode);
    }
  },

  showAwarding: function(awarding) {
    console.debug('*** SHOW AWARDING: ', awarding); //###
    var year = awarding.year;
    var itsGroup = aiki.find(this._groups, function(group) {
      return group.firstYear <= year && year <= group.lastYear;
    });
    console.debug('** group: ', itsGroup); //###
    if (itsGroup) {
      this._openGroup(itsGroup);
      var awardingNode = dojo.byId(this._domId(awarding));
      console.debug('** node: ', this._domId(awarding), awardingNode); //###
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
})();
