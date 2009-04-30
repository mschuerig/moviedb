dojo.provide('aiki._base');

(function(a) {

   a.find = function(/*Array|String*/arr, /*Function|String*/callback, /*Object?*/thisObject) {
     var pred = dojo.hitch(thisObject, callback);
     var result;
     var found = dojo.some(arr, function(v){
       if(pred(v)) {
         result = v;
         return true;
       }
         return false;
       });
     return result;
   };

   a.groupBy = function(/*Array*/items, /*Function*/extractor) {
     var keys = [];
     var groups = {};
     for (var i = 0, l = items.length; i < l; i++) {
       var item = items[i];
       var key = extractor(item);
       var group = groups[key];
       if (!group) {
         keys.push(key);
         group = groups[key] = [];
       }
       group.push(item);
     }
     return { keys: keys, groups: groups };
   };

   a.relay = function(/*Object*/source, /*Object*/dest /*, String ... */) {
     for (var i = 2, l = arguments.length; i < l; i++) {
       var event = arguments[i];
       dojo.connect(source, event, dest, event);
     }
   };

})(aiki);
