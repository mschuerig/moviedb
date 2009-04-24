dojo.provide('moviedb.PeopleGrid');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');
dojo.require('dijit.form.Form');
dojo.require('dijit.form.TextBox');
dojo.require('dijit.layout.BorderContainer');
dojo.require('dijit.layout.ContentPane');
//dojo.require('dojo.i18n');
dojo.require('dojox.form.BusyButton');
dojo.require('dojox.grid.DataGrid');
dojo.require('moviedb.Form');

dojo.declare('moviedb.PeopleGrid', [dijit._Widget, dijit._Templated], {
  store: null,
  sortInfo: 1,
  rowsPerPage: 50,
  keepRows: 200,
  baseClass: 'moviedbPeopleGrid',
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
    console.warn(this.gridNode);
    this.grid = new dojox.grid.DataGrid({
      structure: this._gridStructure,
      store: this.store,
      sortInfo: this.sortInfo,
      keepRows: this.keepRows,
      rowsPerPage: this.rowsPerPage
    }, this.gridNode);
    console.warn(this.grid._started); //### REMOVE
    this.grid.startup();

/* ### TODO make sure tooltips are removed again
      moviedb.installTooltips(grid, function(e) {
        var person = e.grid.getItem(e.rowIndex);
        if (person && person.dob) {
          var msg = 'born ' + person.dob; //### TODO i18n
          dijit.showTooltip(msg, e.cellNode);
        }
      });
*/
/*
    dojo.connect(this.formNode, 'onSubmit', dojo.hitch(this, function(event) {
      dojo.stopEvent(event);
      var value = this.queryNode.attr('value');
      this.gridNode.setQuery({ name: value == '' ? '*' : value });
    }));

    dojo.connect(this.gridNode, 'onRowDblClick', function(event) {
      dojo.publish('person.selected', [grid.getItem(event.rowIndex)]);
    });
*/
  }
});
