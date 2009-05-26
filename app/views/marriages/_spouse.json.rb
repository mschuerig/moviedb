{
###  '$ref'     => marriage_path(marriage),
  :person    => (render :partial => 'people/short', :locals => { :person => marriage.spouse }),
  :startDate => marriage.start_date,
  :endDate   => marriage.end_date
}
