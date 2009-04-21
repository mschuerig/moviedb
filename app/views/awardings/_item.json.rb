{
  :id     => awarding.to_param,
  :year   => awarding.year,
  :movies => awarding.movies.map { |m| render :partial => 'movies/short', :locals => { :movie  => m } },
  :people => awarding.people.map { |p| render :partial => 'people/short', :locals => { :person => p } }
}
