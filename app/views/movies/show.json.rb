{
  :id          => movie_path(@movie),
  :title       => @movie.title,
  :releaseDate => @movie.release_date,
  :summary     => @movie.summary,
  :actors      => @movie.roles.as_actor.map { |role|
    render :partial => 'roles/actor', :locals => { :role => role }
  },
  :directors   => @movie.participants.as_director.map { |director|
    render :partial => 'people/item', :locals => { :person => director }
  }
=begin
  ,
  :awardings   => @movie.awardings.map { |awarding|
    render :partial => 'awardings/short', :locals => { :awarding => awarding }
  }
=end
}
