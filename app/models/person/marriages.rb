
class Person
  has_many :marriages, :order => 'marriages.start_date' do
    def during(options)
      dates = Person.dates_from_options(options)
      overlap = SqlHelper.overlaps(:from_date, :until_date, 'start_date', 'COALESCE(end_date, NOW())')
      self.scoped(:conditions => [overlap, dates])
    end
    
    def at(date)
      self.first(:conditions => [
        "(start_date <= :date) AND (:date <= COALESCE(end_date, NOW()))",
        { :date => date }
      ])
    end
    
    def current
      at(Date.today)
    end

    def status(date = Date.today)
      case
      when self.empty?
        :unmarried
      when (self.last.end_date || Date.today) < date
        :divorced
      else
        :married
      end
    end
  end

  named_scope :unmarried, lambda { |*args|
    options = args.first || {}
    dates   = dates_from_options(options)
    overlap = SqlHelper.overlaps(:from_date, :until_date, 'start_date', 'COALESCE(end_date, NOW())')
    {
      :conditions => [
        "people.id NOT IN (SELECT person_id FROM marriages WHERE #{overlap})",
        dates
      ]
    }
  }
  
  named_scope :married ### TODO

=begin
  # see https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2186
  module SpouseAt
    def at(date)
      proxy_owner.marriages.at(date).try(:spouse)
    end
  end
=end

  has_one :spouse, :through => :marriages,
    :conditions => 'marriages.end_date IS NULL' #,
#    :extend => SpouseAt

  private
  
  def self.dates_from_options(options)
    {
      :from_date  => options[:from]  || options[:at] || Date.today,
      :until_date => options[:until] || options[:at] || Date.today
    }
  end
end
