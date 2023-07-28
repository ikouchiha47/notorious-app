module ProductsHelper
  def size_options_for_select(size_chart = [])
    size_chart.map do |chart| 
      [size_to_text(chart), chart[:size]]
    end
  end

  def size_to_text(chart)
    "#{chart[:size]}-#{chart[:measurement]} #{chart[:measured_in]}"
  end
end
