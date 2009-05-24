hash = {
  '$ref'         => person_path(person),
  :firstname     => person.firstname,
  :lastname      => person.lastname,
  :dob           => person.date_of_birth
}
hash[:serial_number] = person.serial_number if person.serial_number
hash