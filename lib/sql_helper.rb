
module SqlHelper

  def self.overlaps_predicate(period1_start, period1_end, period2_start, period2_end)
  <<-SQL
  ((#{symstr(period1_start)} BETWEEN #{symstr(period2_start)} AND #{symstr(period2_end)}) OR
   (#{symstr(period1_end)  } BETWEEN #{symstr(period2_start)} AND #{symstr(period2_end)}) OR
   ((#{symstr(period1_start)} <= #{symstr(period2_start)})
    AND (#{symstr(period2_end)} <= #{symstr(period1_end)})))
    SQL
  end
  
  def self.dates_from_options(options)
    {
      :from_date  => options[:from]  || options[:at] || Date.today,
      :until_date => options[:until] || options[:at] || Date.today
    }
  end

  private
  
  def self.symstr(sym)
    sym.kind_of?(Symbol) ? ":#{sym}" : sym
  end
end