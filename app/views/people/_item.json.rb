{
#  :id    => person.to_param,
  '$ref' => person_path(person),
  :name  => person.name,
  :dob   => person.date_of_birth
}
