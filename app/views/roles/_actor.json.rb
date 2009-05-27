{
  :actor      => (render :partial => 'people/item', :locals => { :person => role.person }),
  :character  => (render :partial => 'characters/short',
                    :locals => { :character => role.characters[0] }),
  :creditedAs => role.credited_as
}
