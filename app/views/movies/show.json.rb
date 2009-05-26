{
  :id          => @movie.to_param,
  :title       => @movie.title,
  :releaseDate => @movie.release_date,
  :summary     => @movie.summary,
  :actors      => @movie.roles.as_actor.map { |role|
    render :partial => 'roles/actor', :locals => { :role => role }
  },
  :directors   => @movie.roles.as_director.map { |role|
    render :partial => 'roles/director', :locals => { :role => role }
  },
  :awardings   => @movie.awardings.map { |awarding|
    render :partial => 'awardings/short', :locals => { :awarding => awarding }
  }
}
