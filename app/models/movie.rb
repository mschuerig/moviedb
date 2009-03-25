class Movie < ActiveRecord::Base
  attr_protected :release_year
  
  validates_presence_of :title

  has_many :roles, :include => :role_type, :dependent => :destroy

  module ParticipantTypeExtensions
    RoleType.each_name do |name|
      define_method("as_#{name}") do
        self.scoped(
          :joins => 'JOIN role_types ON roles.role_type_id = role_types.id',
          :conditions => { :role_types => { :name => name } })
      end

      ### FIXME is the added role recognized at once?
      class_eval <<-END
        def add_#{name}(person, options = {})
          proxy_owner.roles.build(
            :person => person,
            :role_type => RoleType[:#{name}],
            :credited_as => options[:as]
          )
        end
      END
    end
  end
  
  has_many :participants, :through => :roles, :source => :person, :extend => ParticipantTypeExtensions

  has_and_belongs_to_many :awardings
  
  default_scope :order => 'title, release_date'
  
  def self.in_year_condition(year)
    ["movies.release_year = ?",year]
  end

  named_scope :in_year, 
    lambda { |year| { :conditions => in_year_condition(year) } }

  def self.by_year
    find(:all).group_by(&:release_year).sort_by(&:first)
  end
  
  def before_save
    self.release_year = release_date.blank? ? nil : release_date.year
  end
end
