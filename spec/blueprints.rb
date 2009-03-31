
require 'faker'

class Date
  def self.rand(from = Date.new(1970, 1, 1), to = Date.today)
    days = (to - from).to_i
    from + Kernel.rand(days + 1)
  end
end

Sham.define do
  lastname  { Faker::Name.last_name }
  firstname  { Faker::Name.first_name }
  title { Faker::Lorem.sentence }
  release_date { Date.rand }
  date_of_birth { Date.rand(100.years.ago, 10.years.ago) }
  shaky_date_of_birth { rand < 0.2 ? nil : date_of_birth }
end

Person.blueprint do
  firstname
  lastname
  date_of_birth { Sham.shaky_date_of_birth }
end

Movie.blueprint do
  title
  release_date
end
