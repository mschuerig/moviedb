dojo.provide('moviedb.ui._MovieEditor.Controller');
dojo.require('aiki.Action');

dojo.declare('moviedb.ui._MovieEditor.Controller',
  [moviedb.ui._generic.EditorController], {
    
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
    console.debug('*** ADD AS ROLE: ', role, person); //### TODO
  },
  
  _hasRole: function(role, person) {
    return false; //### TODO
  }
});
