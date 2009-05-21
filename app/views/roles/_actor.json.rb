{
  :actor      => (render :partial => 'people/item', :locals => { :person => person }),
  :character  => { :name => 'N.N.', '$ref' => '/characters/0' },
  :creditedAs => credited_as
}
