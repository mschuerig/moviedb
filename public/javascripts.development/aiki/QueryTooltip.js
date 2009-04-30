dojo.provide('aiki.QueryTooltip');
dojo.require('dijit.Tooltip');
dojo.require('dojo.i18n');
dojo.require('dojox.dtl._Templated');

dojo.declare('aiki.QueryTooltip', dijit.Tooltip, {
  position: ['below', 'above'],
  queryParser: null,

  postMixInProperties: function() {
    this.label = //### TODO template
      '<p>You can just enter a string or filter by these attributes:</p>' +
      + '<ul>' + dojo.map(this.queryParser.allowedAttributes, function(attr) {
      return "<li>" + attr + "</li>";
    }).join('') + "</ul>"
    + '<p><em>e.g.</em> foo:bar</p>';
  }
});
