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

dojo.declare('moviedb.PeopleGrid', [dijit.layout.BorderContainer, dijit._Templated], {
  store: null,
  sortInfo: 1,
  query: {name: '*'},
  rowsPerPage: 50,
  keepRows: 300,
  templatePath: dojo.moduleUrl('moviedb', 'templates/PeopleGrid.html'),
  widgetsInTemplate: true,

  _gridStructure: [
    { name: "Name",
      get: function(_, item) { return item ? item.getName() : '...'; },
      field: 'name',
      width: "100%"
    }
  ],

  postCreate: function() {
    this.inherited(arguments);

    var grid = this.gridNode;

    grid.attr('structure', this._gridStructure);
    grid.setSortInfo(this.sortInfo);
    grid.setQuery(this.query);
    grid.attr('keepRows', this.keepRows);
    grid.setStore(this.store);

    dojo.connect(this.formNode, 'onSubmit', dojo.hitch(this, function(event) {
      dojo.stopEvent(event);
      var value = this.queryNode.attr('value');
      grid.setQuery({ name: value == '' ? '*' : value });
    }));

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
