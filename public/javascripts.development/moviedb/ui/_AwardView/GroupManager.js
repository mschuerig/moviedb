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

function awardingsListContains(awardings, theAwarding) {
  if (!theAwarding) {
    return false;
  }
  return dojo.some(awardings, function(it) { return it.id == theAwarding.id; });
}

dojo.declare('moviedb.ui._AwardView.GroupManager', null, {
  hiliteDuration: 2000,
  _groups: [],

  constructor: function(domIdMaker) {
    this._domId = domIdMaker;
  },

  add: function(titlePane, awardings) {
    this._groups.push({ titlePane: titlePane, awardings: awardings });
  },

  openTopGroup: function() {
    var topGroup = this._groups[0];
    if (topGroup) {
      this._openGroup(topGroup);
      dijit.scrollIntoView(topGroup.titlePane.domNode);
    }
  },

  showAwarding: function(awarding) {
    var itsGroup = aiki.find(this._groups,
      function(group) { return awardingsListContains(group.awardings, awarding); });
    if (itsGroup) {
      this._openGroup(itsGroup);
      var awardingNode = dojo.byId(this._domId(awarding));
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
