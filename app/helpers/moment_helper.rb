module MomentHelper
  def str_to_date(date_time_str)
    begin
      DateTime.parse(date_time_str)
    rescue ArgumentError
      nil
    end
  end
end
