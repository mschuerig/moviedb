dojo.provide('moviedb.EditorManager');

dojo.declare('moviedb.EditorManager', null, {
  editors: [],
  constructor: function(container) {
    this.container = dijit.byId(container);
    dojo.subscribe(this.container.id + '-removeChild', this, 'editorClosed');
  },
  edit: function(object, createEditorWidget) {
    var editor = dojo.find(this.editors, function(item) {
      return item.object === object;
    });
    if (!editor) {
      editor = this._makeEditor(object, createEditorWidget);
    }
    this.container.selectChild(editor.widget);
    return editor.widget;
  },
  editorClosed: function(widget) {
    this.editors = dojo.filter(this.editors, function(item) {
      return item.widget !== widget;
    });
  },
  _makeEditor: function(object, createEditorWidget) {
    var widget = createEditorWidget();
    widget = dojo.mixin(widget, {
      showLabel: true,
      title: widget.getTitle(),
      closable: true,
      onClose: this._makeOnCloseHandler(widget)
    });
    this.container.addChild(widget);
    this.editors.push({object: object, widget: widget});
    if (this.container.tablist) {
      var tabButton = this.container.tablist.pane2button[widget];
      dojo.connect(widget, 'onChange', function() {
        var title = widget.getTitle();
        widget.attr('title', title);
        tabButton.attr('label', title);
      });
    }
    return { object: object, widget: widget };
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
