
class Person
  has_many :marriages, :order => 'marriages.start_date' do
    def during(dates)
      self.select { |marriage| marriage.overlaps?(dates) }
    end

    def at(date)
      self.during(:date => date).first
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

  has_one :marriage, :conditions => 'end_date IS NULL', :extend => (Module.new do
    ### FIXME doesn't work
    # see https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2186
    def at(date)
      proxy_owner.marriages.during(:date => date).first
    end
  end)

  has_one :spouse, :through => :marriage, :extend => (Module.new do
    ### FIXME doesn't work
    # see https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2186
    def at(date)
      proxy_owner.marriages.during(:date => date).first.try(:spouse)
    end
  end)

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

end
