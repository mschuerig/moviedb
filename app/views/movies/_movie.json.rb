m = {
  :id => movie.to_param,
  :title => movie.title,
  :release_year => movie.release_year
}
unless movie.awardings.empty?
  m[:awards] = movie.awardings.map(&:name) ### TODO name + href
end
m
