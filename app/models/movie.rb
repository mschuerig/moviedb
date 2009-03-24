class Movie < ActiveRecord::Base
  attr_protected :release_year
  
  validates_presence_of :title

  has_many :roles, :include => :role_type, :dependent => :destroy

  module ParticipantTypeExtensions
    RoleType.each_name do |name, clean_name|
      define_method("as_#{clean_name}") do
        self.scoped(
          :joins => 'JOIN role_types ON roles.role_type_id = role_types.id',
          :conditions => { :role_types => { :name => name }})
      end
    end
  end
  
  has_many :participants, :through => :roles, :source => :person, :extend => ParticipantTypeExtensions

  has_and_belongs_to_many :awardings
  
  default_scope :order => 'title, release_date'
  
  RoleType.each_name do |name, clean_name|
    class_eval <<-END
      def add_#{clean_name}(person, options = {})
        roles.build(
          :person => person,
          :role_type => RoleType.find_by_name!('#{name}'),
          :credited_as => options[:as]
        )
      end
    END
  end
    
  def self.in_year_condition(year)
    ["movies.release_year = ?",year]
  end

  named_scope :in_year, 
    lambda { |year| { :conditions => in_year_condition(year) } }

  def self.by_year
    find(:all).group_by(&:release_year).sort_by(&:first)
  end
  
  def to_json(options = {})
    if options[:format] == :dojo
      JsonSerializer.new(self, options.reverse_merge(:only => [:id, :title, :release_year])).to_s
    else
      super
    end
  end
  
  def before_save
    self.release_year = release_date.blank? ? nil : release_date.year
  end
end
