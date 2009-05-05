@people.map { |p|
  render :partial => 'people/item', :locals => { :person => p }
}
