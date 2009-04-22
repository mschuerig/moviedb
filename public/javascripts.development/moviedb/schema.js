dojo.provide('moviedb.schema');
dojo.provide('moviedb.Movie');

dojo.declare('moviedb.Movie', null, {
  displayTitle: function() {
    return this.title + ' (' + this.releaseYear + ')';
  }
});

dojo.declare('moviedb.Person', null, {
  getName: function() {
    return this.firstname ? dojo.string.substitute('${firstname} ${lastname}', this) : this.name;
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
      firstname: { type: 'string' },
      lastname: { type: 'string' },
      dob: { type: 'date', format: 'date-time' }
    },
    prototype: moviedb.Person.prototype
  }
});
