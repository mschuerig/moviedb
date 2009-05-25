
class Person
  has_many :marriages do
    def at(date)
      self.first(:conditions => [
        "(start_date <= :date) AND (:date <= COALESCE(end_date, NOW()))",
        { :date => date }
      ])
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
end
