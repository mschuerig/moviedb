m =  {
#  :id          => movie.to_param,
  '$ref'       => movie_path(movie),
  :title       => movie.title,
  :releaseDate => movie.release_date
}
unless movie.awardings.empty?
  m[:awards] = movie.awardings.map { |a|
    render :partial => 'awardings/short.json.rb',
      :locals => { :awarding => a }
  }
end
m
