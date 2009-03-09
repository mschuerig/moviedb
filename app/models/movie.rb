class Movie < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :release_date

  has_many :roles, :include => :role_type, :dependent => :destroy

  module ParticipantTypeExtensions
    RoleType.each_name do |name, clean_name|
      define_method("as_#{clean_name}") do
        self.find(:all,
                  :joins => 'JOIN role_types ON roles.role_type_id = role_types.id',
                  :conditions => { :role_types => { :name => name }})
      end
    end
  end
  
  has_many :participants, :through => :roles, :source => :person, :extend => ParticipantTypeExtensions

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
    
  named_scope :in_year, lambda { |year|
    { 
      :conditions => ["movies.release_date between date(':year-01-01') and date(':year-12-31')",
                      { :year => year }]
    }
  }
end
