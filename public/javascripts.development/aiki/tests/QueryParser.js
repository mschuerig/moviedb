dojo.provide('aiki.tests.QueryParser');
dojo.require('aiki.QueryParser');

(function() {

   var attributes = ['firstname', 'lastname', 'name', 'dob'];
   var defaultAttribute = 'name';

   doh.assertQuery = function(expected, actual, hint) {
     var failures = [];
     for (var i = 0; i < attributes.length; i++) {
       var attr = attributes[i];
       if (expected[attr] !== actual[attr]) {
         failures.push([attr, expected[attr], actual[attr]]);
       }
     }
     if (failures.length > 0) {
       var mismatches = '';
       for (var i = 0; i < failures.length; i++) {
         var failure = failures[i];
         mismatches += "\t" + failure[0] + ': expected "' + failure[1] + '", actual "' + failure[2] + '"\n';
       }
       throw new doh._AssertFailure("assertQueryResult failed for attributes:\n" + mismatches, hint);
     }
   };

   doh.registerGroup("tests.QueryParser",
     [
       function assignsPlainTextToDefaultAttribute(t) {
         t.assertQuery({ name:"abc def" },
                       tests.QueryParser.parse('abc def'));
       },

       function assignsAttributedTextToAttribute(t) {
         t.assertQuery({ name:"abc def" },
                       tests.QueryParser.parse('name:abc def'));
       },

       function assignsQuotedTextToAttributes(t) {
         t.assertQuery({ firstname:"abc", lastname:"def" },
                       tests.QueryParser.parse('firstname:"abc" lastname:"def"'));
       },

       function assignsLeadingTextToDefaultAttribute(t) {
         t.assertQuery({ name:"abc", lastname:"def" },
                       tests.QueryParser.parse('abc lastname:def'));
       },

       function assignsTrailingTextToDefaultAttribute(t) {
         t.assertQuery({ name:"abc", lastname:"def" },
                       tests.QueryParser.parse('lastname:"def" abc'));
       },

       function assignsMiddlingTextToDefaultAttribute(t) {
         t.assertQuery({ name:"xyz", firstname:"abc", lastname:"def" },
                       tests.QueryParser.parse('firstname:"abc" xyz lastname:def'));
       }
     ],
     function setUp() {
       tests.QueryParser = new aiki.QueryParser(attributes, defaultAttribute);
     }
   );
 })();
