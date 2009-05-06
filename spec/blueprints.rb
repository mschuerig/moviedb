
require 'machinist'
require 'faker'

class Date
  def self.rand(from = Date.new(1970, 1, 1), to = Date.today)
    days = (to - from).to_i
    from + Kernel.rand(days + 1)
  end
end

Sham.define do
  lastname(:unique => false) { Faker::Name.last_name }
  firstname(:unique => false) { Faker::Name.first_name }

  title(:unique => false) { Faker::Lorem.sentence(1) }
  release_date(:unique => false) { Date.rand }
  summary {  Faker::Lorem.paragraphs.join("\n") }

  date_of_birth(:unique => false) { Date.rand(100.years.ago, 10.years.ago) }
  shaky_date_of_birth(:unique => false) { rand < 0.2 ? nil : date_of_birth }
end

Person.blueprint do
  firstname
  lastname
  date_of_birth { Sham.shaky_date_of_birth }
end

Movie.blueprint do
  title
  release_date
  summary
end
