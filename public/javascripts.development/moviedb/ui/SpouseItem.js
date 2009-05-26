dojo.provide('moviedb.ui.SpouseItem');
dojo.require('dijit._Widget');
dojo.require('aiki._DataTemplated');
dojo.require('dojo.i18n');
dojo.requireLocalization('moviedb', 'people');

dojo.declare('moviedb.ui.SpouseItem', [dijit._Widget, aiki._DataTemplated], {
  item: null,
  store: null,
  templatePath: dojo.moduleUrl('moviedb', 'ui/_SpouseItem/SpouseItem.html'),
  
  postMixInProperties: function() {
    this._nls = dojo.i18n.getLocalization('moviedb', 'people');
    this.inherited(arguments);
    
    this.endDate = this.store.getValue(this.item, 'endDate');
    if (!this.endDate) {
      this.endDate = this._nls.presentDate;
    }
  }
});
