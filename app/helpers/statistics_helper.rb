module StatisticsHelper

  def format_percentage value, total
    
    if value.nil? || total.nil?
      "0.00%"
    else
      number_to_percentage(value.to_f / total * 100, :precision => 2)
    end
  end
end
