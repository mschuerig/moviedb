dojo.provide('moviedb.ui.PeopleGrid');
dojo.require('dijit._Templated');
dojo.require('dijit.form.Form');
dojo.require('dijit.form.TextBox');
dojo.require('dijit.layout.BorderContainer');
dojo.require('dijit.layout.ContentPane');
dojo.require('dojo.date.locale');
dojo.require('dojo.i18n');
dojo.require('dojox.form.BusyButton');
dojo.require('dojox.grid.DataGrid');
dojo.require('aiki.BusyForm');
dojo.require('aiki._QueriedListMixin');
dojo.requireLocalization('moviedb', 'people');

dojo.declare('moviedb.ui.PeopleGrid',
    [dijit.layout.BorderContainer, dijit._Templated, aiki._QueriedListMixin], {
  store: null,
  sortInfo: 1,
  query: {name: '*'},
  actions: null,
  rowsPerPage: 50,
  keepRows: 300,
  templatePath: dojo.moduleUrl('moviedb', 'ui/_PeopleGrid/PeopleGrid.html'),
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

  postMixInProperties: function() {
    this._nls = dojo.i18n.getLocalization('moviedb', 'people');
    this.inherited(arguments);
  },

  postCreate: function() {
    this.inherited(arguments);

    var grid = this.gridNode;
    this._initGrid(grid, this);

    this._connectGridTopics('person', grid);
    this._connectButtonTopics('person', {
      'new':    this.newPersonNode,
      'delete': this.deletePersonNode 
    });

    this._connectQuerying(grid, this.queryNode, this.queryFieldNode,
    this.allowedQueryAttributes, this.defaultQueryAttribute);

    dojo.connect(grid, 'onCellContextMenu', dojo.hitch(this, '_gridCellContextMenu'));

    var dobTemplate = this._nls.dob;
    this._gridTooltips(grid, function(person) {
      if (person.dob) {
        var dob = dojo.date.locale.format(person.dob, {selector: 'date'});
        return dojo.string.substitute(dobTemplate, {dob: dob});
      }
    });
  },
  
//### TODO extract
  _gridCellContextMenu: function(e) {
    var context = { person: e.grid.getItem(e.rowIndex) };
    var actions = this._getActions(context);
    if (actions.length > 0) {
      var menu = new dijit.Menu({targetNodeIds: e.cellNode});

      dojo.forEach(actions, function(action) {
        menu.addChild(new dijit.MenuItem({
          label:    action.label,
          onClick:  dojo.partial(action.execute, context),
          disabled: action.disabled
        }));
      });
      
      dojo.connect(menu, 'onClose', function() {
//### FIXME        menu.destroyRecursive();
      });
      menu.startup();
      menu._openMyself(e);
    }
  },

  _getActions: function(context) {
    if (this.actions) {
      return dojo.isFunction(this.actions) ? this.actions(context) : this.actions;
    } else {
      return [];
    } 
  }
});
