dojo.provide('moviedb.schema');
dojo.provide('moviedb.Movie');
dojo.provide('moviedb.Person');

dojo.declare('moviedb.Movie', null, {
  displayTitle: function() {
    return this.title + ' (' + this.releaseYear + ')';
  }
});

dojo.declare('moviedb.Person', null, {
  getName: function() {
    return dojo.string.substitute('${firstname} ${lastname}', this);
  }
});

//### TODO check whether schema references are ok
dojo.setObject('moviedb.schema', {
  award: {
    id : 'award',
    type: 'object',
    properties: {
      title: { type: 'string' },
      children: {
        type: 'array',
        optional: true,
        items: { '$ref': 'award' }
      },
      awardings: {
        type: 'array',
        optional: true,
        items: { '$ref': 'awarding' }
      }
    }
  },
  awarding: {
    id: 'awarding',
    name: { type: 'string' },
    year: { type: 'integer' },
    people: {
      type: 'array',
      optional: true,
      items: { '$ref': 'person' }
    },
    movies: {
      type: 'array',
      optional: true,
      items: { '$ref': 'movie' }
    },
    award: { '$ref': 'award' }
  },
  movie: {
    id :'movie',
    type: 'object',
    properties: {
      id: { type: 'integer' },
      title: { type: 'string' },
      releaseDate: { type: 'date', format: 'date-time' },
      summary: { type: 'string' },
      awardings: {
        type: 'array',
        optional: true,
        items: { '$ref': 'awarding' }
      }
    },
    prototype: moviedb.Movie.prototype
  },
  person: {
    id: 'person',
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
