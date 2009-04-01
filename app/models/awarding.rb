class Awarding < ActiveRecord::Base
  validates_presence_of :award, :year
  belongs_to :award
  
  module PeopleExtensions
    RoleType.each_name do |name|
      define_method("as_#{name}") do
        self.scoped(
          :joins => 'INNER JOIN role_types ON roles.role_type_id = role_types.id',
          :conditions => { :role_types => { :name => name } })
      end
    end
  end
  
  has_and_belongs_to_many :people, :extend => PeopleExtensions
  has_and_belongs_to_many :movies
  
  def name
    "#{award.fullname} (#{year})"
  end
  
  def requirements
    award ? award.requirements : []
  end
  
  def validate
    award.try(:validate_awarding, self)
  end
  
  def before_validation
    if year.blank?
      if movie = single_movie
        self.year = movie.release_year
      end
    end
  end
  
  def after_find
    readonly!
  end
  
  def single_movie
    return movies[0] if movies.size == 1
  end

  private
  
  def create_or_update
    super
  rescue ActiveRecord::StatementInvalid => e
    if e.message.include?('are not unique')
      errors.add_to_base('The award can only be given once per year.')
      false
    else
      raise
    end
  end

end
