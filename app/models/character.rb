class Character < ActiveRecord::Base
  validates_presence_of :name
  has_and_belongs_to_many :roles
=begin
  do
    def movies
      self.map(&:movie)
    end
    def actors
      self.map(&:person)
    end
  end
=end  
  def movies
    roles.all(:include => :movie).map(&:movie)
  end
  
  def actors
    roles.all(:include => :person).map(&:actor)
  end
end
