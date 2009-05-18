path = person_path(person)
{
  :id         => path,
  '$ref'      => path,
  :firstname  => person.firstname,
  :lastname   => person.lastname,
  :dob        => person.date_of_birth,
  :creditedAs => credited_as
}
