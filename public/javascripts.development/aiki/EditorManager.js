dojo.provide('aiki.EditorManager');
dojo.require('aiki._base');

dojo.declare('aiki.EditorManager', null, {
  // summary:
  //   Manage a list of objects and their associated editors.
  //
  _editors: [],

  constructor: function(options) {
    if (options) {
      dojo.mixin(this, options);
    }
    this.container = dijit.byId(this.container);
    dojo.subscribe(this.container.id + '-removeChild', this, 'editorClosed');
  },

  edit: function(object, store, widgetType, /* Object? */options) {
    options = options || {};
    if (dojo.isString(object)) {
      store.fetchItemByIdentity({
        identity: object,
        scope: this,
        onItem: function(item) { this._edit(item, store, widgetType, options); }
      });
    } else {
      this._edit(object, store, widgetType, options);
    }
  },

  _edit: function(object, store, widgetType, options) {
    var editor = this._editorForObject(object);
    if (!editor) {
      editor = this._makeEditor(object, store, widgetType, options);
      this.selectEditor(editor);
    } else {
      this.selectEditor(editor);
      if (options.onReady) {
        options.onReady(editor.widget, editor.object);
      }
    }
    return editor.widget;
  },

  selectEditor: function(editor) {
    var widget = editor.widget;
    this.container.selectChild(widget);
  },

  editorClosed: function(widget) {
    this._editors = dojo.filter(this._editors, function(item) {
      return item.widget !== widget;
    });
  },

  _makeEditor: function(object, store, widgetType, options) {
    //### TODO keep widget options and our own apart
    widgetType = dojo.isString(widgetType) ? dojo.getObject(widgetType) : widgetType;
    var widget = new widgetType(dojo.mixin(options,
      { store: store, object: object }));

    if (options.onReady) {
      dojo.connect(widget, 'startup', dojo.partial(options.onReady, widget, object));
    }

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
  },

  _editorForObject: function(object) {
    return aiki.find(this._editors, function(item) {
      return item.object === object;
    });
  }
});
