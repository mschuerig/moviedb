@movies.map { |m|
  render :partial => 'movies/item', :locals => { :movie => m }
}
