dojo.provide('moviedb.ui.PeopleGrid');
dojo.require('moviedb.ui._QueriedList');
dojo.requireLocalization('moviedb', 'people');

dojo.declare('moviedb.ui.PeopleGrid', moviedb.ui._QueriedList, {
  sortInfo: 1,
  query: {name: '*'},

  gridStructure: [
    { name: "Name",
      get: function(_, item) { return item ? item.getName() : '...'; },
      field: 'name',
      width: "100%"
    }
  ],

  allowedQueryAttributes: ['name', 'firstname', 'lastname', 'birthday', 'dob'],
      defaultQueryAttribute: 'name',

  _contextItemName: 'person',
  _topic: 'person',
  _i18nBundles: ['people'],

  postCreate: function() {
    this.inherited(arguments);

    var dobTemplate = this._nls.dob;
    this._gridTooltips(this.gridNode, function(person) {
      if (person.dob) {
        var dob = dojo.date.locale.format(person.dob, {selector: 'date'});
        return dojo.string.substitute(dobTemplate, {dob: dob});
      }
    });
  }
});
