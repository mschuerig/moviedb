{
  :id        => @person.to_param,
  :firstname => @person.firstname,
  :lastname  => @person.lastname,
  :dob       => @person.date_of_birth,
  :spouses   => @person.marriages.map { |m|
    render :partial => 'marriages/spouse', :locals => { :marriage => m }
  }
}
