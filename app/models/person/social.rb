
class Person

  def coworkers() #options = {})
=begin
    if movie = options[:movie]
      Person.scoped(
        :conditions => [
          "people.id <> ? AND people.id IN" +
          " (SELECT roles.person_id FROM roles WHERE roles.movie_id = ?)",
          id, movie
        ]
      )
    else
=end
      Person.scoped(
        :conditions => [
        "people.id <> ? AND people.id IN" +
        " (SELECT roles.person_id FROM roles WHERE roles.movie_id IN" +
        " (SELECT roles.movie_id from roles WHERE roles.person_id = ?))",
        id, id]
      )
#    end
  end
end
