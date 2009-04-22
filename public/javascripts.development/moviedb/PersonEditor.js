dojo.provide('moviedb.PersonEditor');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');
dojo.require('dijit.form.ValidationTextBox');
dojo.require('dijit.form.DateTextBox');
dojo.require('dojox.form.BusyButton');
dojo.require('dojox.dtl._Templated');
dojo.require('moviedb.Form');

dojo.declare('moviedb.PersonEditor', [dijit._Widget, dijit._Templated], {
  store: null,
  object: null,

  baseClass: 'moviedbPersonEditor',
  templatePath: dojo.moduleUrl('moviedb', 'templates/PersonEditor.html'),
  widgetsInTemplate: true,

  startup: function() {
    console.warn(this); //### REMOVE
    dojo.connect(this.formNode, 'onChange', this, 'onChange');
    this.formNode.populate(this.store, this.object);
  },
  getTitle: function() {
    if (this.firstnameField) {
      return this.firstnameField.attr('value') + ' ' + this.lastnameField.attr('value');
    } else {
      return 'Loading...'; //### TODO i18n
    }
  },
  isModified: function() {
    return this.formNode.isModified();
  },
  onChange: function() {
    console.log('*** PERSON ON CHANGE');
  }
});
