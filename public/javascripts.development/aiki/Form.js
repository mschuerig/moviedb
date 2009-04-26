dojo.provide('aiki.Form');
dojo.require('dijit.form.Form');
dojo.require('aiki.form._ButtonsMixin');
dojo.require('aiki.form._DataMixin');
dojo.require('aiki.form._ModificationEventsMixin');

dojo.declare('aiki.Form', [dijit.form.Form,
  aiki.form._DataMixin, aiki.form._ButtonsMixin, aiki.form._ModificationEventsMixin], {

  onSubmit: function() {
    if (this.isValid()) {
      this.save();
    }
    return false;
  },
  onReset: function() {
    this.resetSubmitButtons();
    return this.inherited(arguments);
  },
  onPopulated: function(object) {
    this.onChange();
    this.markUnmodified();
    this.resetSubmitButtons();
    this.watchForChanges();
  },
  onSaved: function() {
    this.markUnmodified();
    this.resetSubmitButtons();
  }
});
