{
  :director   => (render :partial => 'people/item', :locals => { :person => role.person }),
  :creditedAs => role.credited_as
}
