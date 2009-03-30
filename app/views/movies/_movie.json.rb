m = {
  :id => movie.to_param,
  :title => movie.title,
  :releaseDate => movie.release_date
}
unless movie.awardings.empty?
  m[:awards] = movie.awardings.map(&:name) ### TODO name + href
end
m
