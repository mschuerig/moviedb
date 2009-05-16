dojo.provide('moviedb.ui._MovieEditor.Controller');
dojo.require('aiki.Action');

dojo.declare('moviedb.ui._MovieEditor.Controller',
  [moviedb.ui._generic.EditorController], {

  constructor: function() {
    var hilite = function(obj, item) {
      setTimeout(function() { aiki.hilite(item) }, 100); // apparently the DOM or dojo needs some time
    };
    dojo.connect(this.view.actorsNode, 'onObjectAdded', hilite);
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
    var node;
    if (role === 'actor') {
      node = this.view.actorsNode;
    }
    return node ? func(node) : null;
  }
});
