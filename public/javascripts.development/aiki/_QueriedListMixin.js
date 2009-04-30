dojo.provide('aiki._QueriedListMixin');
dojo.require('aiki.QueryParser');
dojo.require('aiki.QueryHelp');

dojo.declare('aiki._QueriedListMixin', null, {
  _initGrid: function(grid, props) {
    grid.attr('structure', props.gridStructure);
    grid.setSortInfo(props.sortInfo);
    grid.setQuery(props.query);
    grid.attr('keepRows', props.keepRows);
    grid.setStore(props.store);
  },

  _connectEvents: function(grid, newItemNode, kind) {
    dojo.connect(newItemNode, 'onSubmit', function(event) {
      dojo.stopEvent(event);
      dojo.publish(kind + '.new');
    });

    dojo.connect(grid, 'onRowDblClick', function(event) {
      dojo.publish(kind + '.selected', [grid.getItem(event.rowIndex)]);
    });
  },

  _connectQuerying: function(grid, queryForm, queryField, allowedAttributes, defaultAttribute) {
    var queryParser = new aiki.QueryParser(allowedAttributes, defaultAttribute);
    this._makeQueryFieldTooltip(this.queryFieldNode, allowedAttributes, defaultAttribute);

    dojo.connect(queryForm, 'onSubmit', function(event) {
      dojo.stopEvent(event);
      var queryStr = queryField.attr('value');
      grid.setQuery(queryParser.parse(queryStr));
    });

    if (dojo.isFunction(queryForm.resetSubmitButtons)) {
      dojo.connect(grid, '_onFetchComplete', function() { // NOTE abuse a DataGrid private hook
        queryForm.resetSubmitButtons();
      });
    }
  },

  _makeQueryFieldTooltip: function(fieldWidget, attributes, defaultAttribute) {
    var help = new aiki.QueryHelp({
      attributes: attributes,
      defaultAttribute: defaultAttribute
    });
    help.render();
    return new dijit.Tooltip({
      connectId: [fieldWidget.domNode],
      label: help.domNode.innerHTML,
      position: ['below', 'above']
    });
  }

});
