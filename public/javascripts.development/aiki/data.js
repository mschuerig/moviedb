dojo.provide('aiki.data');

(function(a) {
   var comparatorPattern = '(?:<=)|(?:>=)|(?:<>)|(?:!=)|=|<|>';
   var queryTerm = '("[^"]*?")|(\'[^\']*?\')|(?:([^:]+)(\\s\\w+:))|([^:]+)';

   a.parseQuery = function(queryStr, allowedAttributes, defaultAttribute) {
     var pat = '(' + allowedAttributes.join('|') + '):(' + comparatorPattern + ')?(?:' + queryTerm + ')';
     var rx = new RegExp(pat, 'gi');
     var query = {};
     var unattr = '', unattrStart = 0, unattrEnd;
     var match, haveMatch;
     while ((match = rx.exec(queryStr))) {
       var attr = match[1], cmp = match[2];
       var target = match[3] || match[4] || match[5] || match[7];
       query[attr] = cmp ? { target: target, comparator: cmp } : target;

       unattrEnd = rx.lastIndex - match[0].length;
       if (unattrEnd > 0) {
         unattr += queryStr.substring(unattrStart, unattrEnd);
         unattrStart = unattrEnd;
       } else {
         unattrStart = rx.lastIndex;
       }

       if (match[6]) {
         rx.lastIndex -= match[6].length;
       }
     }
     if (defaultAttribute && !query.defaultAttribute) {
       unattr = dojo.string.trim(unattr);
       query[defaultAttribute] = (unattr.length > 0) ? unattr : queryStr;
     }
     return query;
   };

 })(aiki);
