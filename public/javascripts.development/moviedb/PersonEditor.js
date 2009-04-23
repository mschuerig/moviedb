dojo.provide('moviedb.PersonEditor');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');
dojo.require('dijit.form.ValidationTextBox');
dojo.require('dijit.form.DateTextBox');
dojo.require('dojo.i18n');
dojo.require('dojox.form.BusyButton');
dojo.require('dojox.dtl._Templated');
dojo.require('moviedb.Form');
dojo.requireLocalization("dijit", "loading");

dojo.declare('moviedb.PersonEditor', [dijit._Widget, dijit._Templated], {
  store: null,
  object: null,

  baseClass: 'moviedbPersonEditor',
  templatePath: dojo.moduleUrl('moviedb', 'templates/PersonEditor.html'),
  widgetsInTemplate: true,

  getFeatures: function(){
    return {
      "moviedb.api.View": true,
      "moviedb.api.Edit": true
    };
  },
  postMixInProperties: function(){
    this.inherited(arguments);
	if(!this.loadingLabel){
      this.loadingLabel = dojo.i18n.getLocalization("dijit", "loading", this.lang).loadingState;
	}
  },
  postCreate: function() {
    dojo.connect(this.formNode, 'onChange',   this, 'onChange');
    dojo.connect(this.formNode, 'onModified', this, 'onModified');
    dojo.connect(this.formNode, 'onReverted', this, 'onReverted');
    this.formNode.populate(this.store, this.object);
  },
  getTitle: function() {
    if (this.firstnameField) {
      return this.firstnameField.attr('value') + ' ' + this.lastnameField.attr('value');
    } else {
      return this.loadingLabel;
    }
  },
  isModified: function() {
    return this.formNode.isModified();
  },
  onChange: function() {
    console.log('*** PERSON ON CHANGE');
  },
  onModified: function() {
  },
  onReverted: function() {
  }
});
