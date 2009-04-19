dojo.provide('moviedb.EditorManager');

dojo.declare('moviedb.EditorManager', null, {
  editors: [],
  constructor: function(container) {
    this.container = dijit.byId(container);
    dojo.subscribe(this.container.id + '-removeChild', this, 'editorClosed');
  },
  edit: function(object, createEditorWidget) {
    console.log('*** edit: ', object); //### REMOVE
    var editor = dojo.find(this.editors, function(item) {
      return item.object === object;
    });
    if (!editor) {
      editor = this._makeEditor(object, createEditorWidget);
    }
    this.container.selectChild(editor.pane);
    console.log('**** DOC WIDGET: ', editor.widget); //### REMOVE
    return editor.widget;
  },
  editorClosed: function(pane) {
    console.log('*** CLOSED: ', pane);
    this.editors = dojo.filter(this.editors, function(item) {
      return item.pane !== pane;
    });
  },
  _makeEditor: function(object, createEditorWidget) {
    var widget = createEditorWidget();
    var title = widget.getTitle();
    var pane = new dijit.layout.ContentPane({
      label: 'foo',
      showLabel: true,
      title: title,
      closable: true,
      onClose: this._makeOnCloseHandler(widget)
    });
    widget.placeAt(pane.containerNode);
    this.editors.push({object: object, pane: pane, widget: widget});
    this.container.addChild(pane);
    if (this.container.tablist) {
      var tabButton = this.container.tablist.pane2button[pane];
      dojo.connect(widget, 'onChange', function() {
        var title = widget.getTitle();
        pane.attr('title', title);
        tabButton.attr('label', title);
      });
    }
    return { object: object, widget: widget, pane: pane };
  },
  _makeOnCloseHandler: function(widget) {
    return function() {
      if (widget.isModified()) {
        return confirm("Are you sure you want to discard your changes?");
      }
      return true;
    };
  }
});
