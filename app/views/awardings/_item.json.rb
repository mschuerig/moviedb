{
  :id => awarding.id,
  :year   => awarding.year,
  :movies => awarding.movies.map(&:title),
  :people => awarding.people.map(&:name)
}
