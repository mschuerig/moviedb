
class Person
  has_many :marriages, :finder_sql => %q{SELECT marriages.* FROM marriages WHERE #{id} IN (person_id, spouse_id)} do
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
  
  def spouse
    
  end
end
