path = person_path(person)
{
  :id    => path,
  '$ref' => path,
  :name  => person.name,
  :dob   => person.date_of_birth
}
