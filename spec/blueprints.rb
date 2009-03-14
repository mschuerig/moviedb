
require 'faker'

class Date
  def self.rand(from = Date.new(1970, 1, 1), to = Date.today)
    days = (to - from).to_i
    from + Kernel.rand(days + 1)
  end
end

Sham.lastname  { Faker::Name.last_name }
Sham.firstname  { Faker::Name.first_name }
Sham.title { Faker::Lorem.sentence }
Sham.release_date { Date.rand }

Person.blueprint do
  firstname
  lastname
end

Movie.blueprint do
  title
  release_date
end
