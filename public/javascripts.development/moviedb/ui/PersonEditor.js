dojo.provide('moviedb.ui.PersonEditor');
dojo.require('moviedb.ui._generic.Editor');
dojo.require('moviedb.ui._PersonEditor.View');

dojo.declare('moviedb.ui.PersonEditor', [moviedb.ui._generic.Editor, moviedb.ui._PersonEditor.View], {

  getTitle: function() {
    if (this.firstnameField) {
      return this.firstnameField.attr('value') + ' ' + this.lastnameField.attr('value');
    } else {
      return this.loadingLabel;
    }
  }

});
