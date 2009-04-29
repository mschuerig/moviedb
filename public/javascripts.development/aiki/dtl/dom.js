dojo.provide("aiki.dtl.dom");

dojo.mixin(aiki.dtl.dom, {
  cleanId: function(value){
    return value.toString().replace(/\W+/g, '_');
  }
});

dojox.dtl.register.filters('aiki.dtl', {
  'dom': ['cleanId']
});
