{
  :identifier => Person.primary_key,
  :totalCount => @count,
  :items => @people.map { |p|
    render :partial => 'people/item', :locals => { :person => p }
  }
}
