module TimezoneHelper
  def time_converter
    Time.zone = "GMT"
    Time.zone.now
  end
end