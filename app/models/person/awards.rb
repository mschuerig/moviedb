
class Person
  has_and_belongs_to_many :awardings, :after_remove => lambda { |_, awarding| awarding.destroy }

end
