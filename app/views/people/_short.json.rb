{
  :id    => person.to_param,
  '$ref' => person_path(person),
  :firstname => person.firstname,
  :lastname  => person.lastname
}
