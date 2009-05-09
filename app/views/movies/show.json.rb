{
  :id          => movie_path(@movie),
  :title       => @movie.title,
  :releaseDate => @movie.release_date,
  :summary     => @movie.summary,
  :actors      => @movie.participants.as_actor.map { |actor|
    render :partial => 'people/item', :locals => { :person => actor }
  }
}
