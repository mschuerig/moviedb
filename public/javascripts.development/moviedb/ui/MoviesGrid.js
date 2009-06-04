dojo.provide('moviedb.ui.MoviesGrid');
dojo.require('moviedb.ui._QueriedList');
//dojo.requireLocalization('moviedb', 'people');

dojo.declare('moviedb.ui.MoviesGrid', moviedb.ui._QueriedList, {
  sortInfo: -2,
/*
  _awardingsFormatter: function(awardings) {
    return awardings ? dojo.string.rep('*', awardings.length) : '';
  },
  _yearFormatter: function(date) {
    return date ? 1900 + date.getYear() : '';
  },
*/
  gridStructure: [
    { field: "title",       name: "Title",  width: "auto" },
    { field: "releaseDate", name: "Year",   width: "5em",
      formatter: function(date) { return date ? 1900 + date.getYear() : ''; } },
    { field: "awardings",      name: "Awards", width: "6em",
      formatter: function(awardings) { return awardings ? dojo.string.rep('*', awardings.length) : ''; } }
  ],

  allowedQueryAttributes: ['title', 'year', 'awards'],
  defaultQueryAttribute: 'title',

  _contextItemName: 'movie',
  _topic: 'movie',

  _getActions: function(context, event) {
    var actions = this.inherited(arguments);
    
    if (event.cell.field == 'awardings') {
      var awardings = this.store.getValue(context.movie, 'awardings');
      if (awardings && awardings.length > 0) {
        actions.push('Awards'); //### i18n
        for (var i = 0; i < awardings.length; i++) {
          var awarding = awardings[i];
          actions.push(new aiki.Action(
            this.store.getValue(awarding, 'title'),
            dojo.hitch(this, '_awardingSelected', awarding)
          ));
        }
      }
    }
    return actions;
  },

  _awardingSelected: function(awarding) {
    var hints = {
      context: 'awardGroup'
    };
    dojo.publish('awarding.selected', [awarding, hints]);
  }
});
