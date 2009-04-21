{
  :identifier => Awarding.primary_key,
  :totalCount => @awardings.size,
  :items => @awardings.map { |aw|
    render :partial => 'awardings/item', :locals => { :awarding => aw }
  }
}
