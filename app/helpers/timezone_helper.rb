module TimezoneHelper
  def time_converter
    Time.zone = "UTC"
    Time.zone.now
  end
end