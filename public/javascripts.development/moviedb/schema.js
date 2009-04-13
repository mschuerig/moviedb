dojo.provide('moviedb.schema');
dojo.provide('moviedb.Movie');

dojo.declare('moviedb.Movie', null, {
  displayTitle: function() {
    return this.title + ' (' + this.releaseYear + ')';
  }
});

dojo.setObject('moviedb.schema', {
  award: {
    type: 'object',
    properties: {
      title: { type: 'string' }
    }
  },
  movie: {
    type: 'object',
    properties: {
      id: { type: 'integer' },
      title: { type: 'string' },
      releaseDate: { type: 'date', format: 'date-time' },
      summary: { type: 'string' },
      awards: {
        type: 'array',
        optional: true,
        items: moviedb.schema.award
      }
    },
    prototype: moviedb.Movie.prototype
  },
  person: {
    type: 'object',
    properties: {
      id: { type: 'integer' },
      name: { type: 'string', readonly: true },
      dob: { type: 'date', format: 'date-time' }
    }
  }
});
