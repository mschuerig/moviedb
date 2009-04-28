path = movie_path(movie)
{
  :id          => path,
  '$ref'       => path,
  :title       => movie.title,
  :releaseDate => movie.release_date,
  :awardings   => movie.awardings.map { |a|
    render :partial => 'awardings/short.json.rb',
      :locals => { :awarding => a }
  }
}
