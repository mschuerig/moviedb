{
  :identifier => Movie.primary_key,
  :totalCount => @count,
  :items => @movies.map { |m| render(m) }
}
