m = {
#  '$ref' => movie.to_param,
  :id => movie.to_param,
  :title => movie.title,
  :releaseDate => movie.release_date
}
unless movie.awardings.empty?
  m[:awards] = movie.awardings.map { |a|
    render :partial => 'awardings/short.json.rb',
      :locals => { :awarding => a }
  }
end
m
