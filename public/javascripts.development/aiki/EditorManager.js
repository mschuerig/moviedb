dojo.provide('aiki.EditorManager');
dojo.require('aiki._base');

dojo.declare('aiki.EditorManager', null, {
  _editors: [],

  constructor: function(options) {
    if (options) {
      dojo.mixin(this, options);
    }
    this.container = dijit.byId(this.container);
    dojo.subscribe(this.container.id + '-removeChild', this, 'editorClosed');
  },
  edit: function(object, store, widgetType) {
    if (dojo.isString(object)) {
      var self = this;
      store.fetchItemByIdentity({
        identity: object,
        onItem: function(item) { self._edit(item, store, widgetType); }
      });
    } else {
      this._edit(object, store, widgetType);
    }
  },
  _edit: function(object, store, widgetType) {
    var editor = aiki.find(this._editors, function(item) {
      return item.object === object;
    });
    if (!editor) {
      editor = this._makeEditor(object, store, widgetType);
    }
    this.container.selectChild(editor.widget);
    return editor.widget;
  },
  editorClosed: function(widget) {
    this._editors = dojo.filter(this._editors, function(item) {
      return item.widget !== widget;
    });
  },
  _makeEditor: function(object, store, widgetType) {
    widgetType = dojo.isString(widgetType) ? dojo.getObject(widgetType) : widgetType;
    var widget = new widgetType({store: store, object: object});
    widget = dojo.mixin(widget, {
      showLabel: true,
      closable: true,
      onClose: this._makeOnCloseHandler(widget)
    });
    this.container.addChild(widget);
    this._editors.push({object: object, widget: widget});
    if (this.container.tablist) {
      var tabButton = this.container.tablist.pane2button[widget];
      var updateTitle = function() {
        var title = widget.getTitle();
        widget.attr('title', title);
        tabButton.attr('label', title);
      };
      updateTitle();
      dojo.connect(widget, 'onChange', updateTitle);
    }
    return { object: object, widget: widget };
  },
  _makeOnCloseHandler: function(widget) {
    if (widget.getFeatures()['aiki.api.Edit']) {
      return function() {
        if (widget.isModified()) {
          return confirm("Are you sure you want to discard your changes?");
        }
        return true;
      };
    } else {
      return function() { return true; };
    }
  }
});
