dojo.provide('moviedb.PeopleGrid');
dojo.require('dijit._Templated');
dojo.require('dijit.form.Form');
dojo.require('dijit.form.TextBox');
dojo.require('dijit.layout.BorderContainer');
dojo.require('dijit.layout.ContentPane');
//dojo.require('dojo.i18n');
dojo.require('dojox.form.BusyButton');
dojo.require('dojox.grid.DataGrid');
dojo.require('aiki.Form');
dojo.require('aiki._QueriedListMixin');

dojo.declare('moviedb.PeopleGrid',
    [dijit.layout.BorderContainer, dijit._Templated, aiki._QueriedListMixin], {
  store: null,
  sortInfo: 1,
  query: {name: '*'},
  rowsPerPage: 50,
  keepRows: 300,
  templatePath: dojo.moduleUrl('moviedb', 'templates/PeopleGrid.html'),
  widgetsInTemplate: true,

  gridStructure: [
    { name: "Name",
      get: function(_, item) { return item ? item.getName() : '...'; },
      field: 'name',
      width: "100%"
    }
  ],

  allowedQueryAttributes: ['name', 'firstname', 'lastname', 'birthday', 'dob'],
      defaultQueryAttribute: 'name',

  postCreate: function() {
    this.inherited(arguments);

    var grid = this.gridNode;
    this._initGrid(grid, this);

    this._connectEvents(grid, this.newPersonNode, 'person');

    this._connectQuerying(grid, this.queryNode, this.queryFieldNode,
      this.allowedQueryAttributes, this.defaultQueryAttribute);

    dojo.connect(grid, 'onRowDblClick', function(event) {
      dojo.publish('person.selected', [grid.getItem(event.rowIndex)]);
    });

/* ### TODO make sure tooltips are removed again
      moviedb.installTooltips(grid, function(e) {
        var person = e.grid.getItem(e.rowIndex);
        if (person && person.dob) {
          var msg = 'born ' + person.dob; //### TODO i18n
          dijit.showTooltip(msg, e.cellNode);
        }
      });
*/
  }
});
