dojo.provide('moviedb.AwardsTree');
dojo.require('dijit.Tree');
dojo.require('dijit.tree.ForestStoreModel');

dojo.declare('moviedb.AwardsTree', dijit.Tree, {
  store: null,
  postMixInProperties: function() {
    this.inherited(arguments);
    this.model = new dijit.tree.ForestStoreModel({
      store: this.store,
      labelAttr: 'name',
      childrenAttrs: ['children']
    });
    this.showRoot = false;
  },
  postCreate: function() {
    this.inherited(arguments);
    dojo.connect(this, 'onDblClick', function(item, node) {
      var hints = {
        awardGroup: node.hasChildren()
      };
      dojo.publish('award.selected', [item, hints]);
    });
  }
});
