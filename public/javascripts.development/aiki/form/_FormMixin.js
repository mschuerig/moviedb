dojo.provide('aiki.form._FormMixin');

dojo.declare('aiki.form._FormMixin', null, {
  forProperties: function(/*Function*/callback) {
    // summary:
    //   Iterate over all child widgets an call callback on each.
    //
    // callback:
    //   function(widgetName, widget)
    //
    // tags:
    //   protected
    var iter = dojo.hitch(this, callback);
    this.getDescendants().forEach(function(widget) {
      if (widget.name) {
        iter(widget.name, widget);
      }
    });
  }
});
