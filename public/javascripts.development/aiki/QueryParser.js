dojo.provide('aiki.QueryParser');

dojo.declare('aiki.QueryParser', null, {

  _comparatorPattern: '(?:<=)|(?:>=)|(?:<>)|(?:!=)|=|<|>',
  _queryTerm: '(?:"([^"]*?)")|(?:\'([^\']*?)\')|(?:([^:]+)(\\s[\\w*]+:))|([^:]+)',

  constructor: function(allowedAttributes, defaultAttribute) {
    this.allowedAttributes = allowedAttributes;
    this.defaultAttribute  = defaultAttribute;
    this.updateRegex();
  },

  updateRegex: function() {
    var pat = '(' + this.allowedAttributes.join('|') + '):(' + this._comparatorPattern + ')?(?:' + this._queryTerm + ')';
    this._rx = new RegExp(pat, 'gi');
  },

  parse: function(queryStr) {
     var query = {};
     var unattr = '', unattrStart = 0;
     var match, haveMatch;
     while ((match = this._rx.exec(queryStr))) {
       var attr = match[1], cmp = match[2];
       var target = match[3] || match[4] || match[5] || match[7];
       query[attr] = cmp ? { target: target, comparator: cmp } : target;

       var matchLength = match[0].length;
       var matchStart  = this._rx.lastIndex - matchLength;

       if (unattrStart < matchStart) {
         unattr += queryStr.substring(unattrStart, matchStart - 1);
       }

       var backoff = match[6];
       if (backoff) {
         this._rx.lastIndex -= backoff.length;
       }
       unattrStart = this._rx.lastIndex;
     }

     if (!this._rx.lastIndex && unattrStart < queryStr.length) {
       unattr += queryStr.substring(unattrStart);
     }

     if (this.defaultAttribute && !query[this.defaultAttribute]) {
       unattr = dojo.trim(unattr);
       if (unattr.length > 0) {
         query[this.defaultAttribute] = unattr;
       }
     }
     return query;
   }
});
