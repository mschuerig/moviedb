class MovieAward < ActiveRecord::Base
  validates_presence_of :name, :award_group
  belongs_to :award_group

  def full_name
    "#{award_group.name}: #{name}"
  end
end
