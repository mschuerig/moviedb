dojo.provide('aiki.form._ButtonsMixin');
dojo.require('dijit.form.Button');

dojo.declare('aiki.form._ButtonsMixin', null, {
  // summary:
  //   Common functions for handling submit buttons in forms.
  //
  resetSubmitButtons: function() {
    // tags:
    //   protected
    this.buttons().forEach(function(button) {
      if (dojo.isFunction(button.cancel)) {
        button.cancel();
      }
    });
  },
  buttons: function() {
    // tags:
    //   protected
    return this.getDescendants().filter(function(widget) {
      return (widget instanceof dijit.form.Button);
    });
  }
});
