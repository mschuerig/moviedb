{
  :id     => awarding.to_param,
  :title  => awarding.name,
  :year   => awarding.year,
  :movies => awarding.movies.map { |m| render :partial => 'movies/short', :locals => { :movie  => m } },
  :people => awarding.people.map { |p| render :partial => 'people/short', :locals => { :person => p } },
  :award  => { '$ref' => award_path(awarding.award) }
}
