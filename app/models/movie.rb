class Movie < ActiveRecord::Base
  concerned_with :roles

  attr_protected :release_year

  acts_as_xapian :texts => [ :title, :summary ],
    :values => [ [ :release_year, 1, 'year', :number ] ]

  validates_presence_of :title
  has_and_belongs_to_many :awardings, :after_remove => lambda { |_, awarding| awarding.destroy }

  default_scope :order => 'title, release_date'

  def self.in_year_condition(year)
    { :movies => { :release_year => year } }
  end

  named_scope :in_year,
    lambda { |year| { :conditions => in_year_condition(year) } }

  def self.by_year
    find(:all).group_by(&:release_year).sort_by(&:first)
  end

  def self.find(*args)
    options = args.extract_options!
    if options[:order] =~ /\bawards\b/i
      tn = table_name
      cols = Movie.column_names.map { |c| "#{tn}.#{c}"}.join(',')
      with_scope(:find => options) do
        super(args[0],
          :select => "#{cols}, COUNT(awardings_movies.movie_id) AS awards",
          :joins => "LEFT OUTER JOIN awardings_movies ON awardings_movies.movie_id = movies.id",
          :group => cols
        )
      end
    else
      args << options
      super(*args)
    end
  end

  def before_validation
    self.release_year = release_date.blank? ? nil : release_date.year
  end
  
end
