dojo.provide('moviedb.PersonEditor');
dojo.require('dijit._Templated');
dojo.require('dijit._Widget');
dojo.require('dijit.form.Textarea');
dojo.require('dijit.form.ValidationTextBox');
dojo.require('dijit.form.DateTextBox');
dojo.require('dojo.i18n');
dojo.require('dojox.form.BusyButton');
dojo.require('aiki.Form');
dojo.requireLocalization("dijit", "loading");

dojo.declare('moviedb.PersonEditor', [dijit._Widget, dijit._Templated], {
  store: null,
  object: null,

  baseClass: 'moviedbPersonEditor',
  iconClass: 'smallIcon personIcon',
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
    this.formNode.populate(this.store, this.object);
    aiki.relay(this.formNode, this,
      'onCreated', 'onSaved', 'onError', 'onChange', 'onModified', 'onReverted');
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

  onCreated: function() {
  },
  onSaved: function() {
  },
  onError: function() {
  },
  onChange: function() {
    console.log('*** PERSON ON CHANGE'); //### REMOVE
  },
  onModified: function() {
  },
  onReverted: function() {
  }
});
