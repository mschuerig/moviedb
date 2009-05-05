@awardings.map { |aw|
  render :partial => 'awardings/item', :locals => { :awarding => aw }
}
