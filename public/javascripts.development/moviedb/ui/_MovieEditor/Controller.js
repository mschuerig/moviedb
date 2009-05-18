dojo.provide('moviedb.ui._MovieEditor.Controller');
dojo.require('aiki.Action');

dojo.declare('moviedb.ui._MovieEditor.Controller',
  [moviedb.ui._generic.EditorController], {

  constructor: function(store, object, view) {
    this._role2listNode = {
      'actor':    this.view.actorsNode,
      'director': this.view.directorsNode
    };
    this._connectHiliting();
  },

  populate: function() {
    this.inherited(arguments);
  },

  getActions: function(context) {
    var person = context.person;

    return [ //### i18n
      this._makeRoleAction('actor',    person, 'Add as Actor'),
      this._makeRoleAction('director', person, 'Add as Director')
    ];
  },

  _makeRoleAction: function(role, person, label) {
    return new aiki.Action(
      label,
      dojo.hitch(this, '_addAsRole', role, person),
      !this._hasRole(role, person)
    );
  },

  _addAsRole: function(role, person) {
    this._doForRole(role, function(list) { return list.addObject(person); });
  },

  _hasRole: function(role, person) {
    return this._doForRole(role, function(list) { return list.hasObject(person); });
  },

  _doForRole: function(role, func) {
    var node = this._role2listNode[role];
    return node ? func(node) : null;
  },

  _connectHiliting: function() {
    var hilite = function(obj, item) {
      // apparently the DOM or dojo needs some time
      setTimeout(function() { aiki.hilite(item) }, 100);
    };
    
    for (var role in this._role2listNode) {
      dojo.connect(this._role2listNode[role], 'onObjectAdded', hilite);
    }
  }
});
