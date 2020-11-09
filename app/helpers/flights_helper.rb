module FlightsHelper
    def duration_fmt
      "#{Time.at(duration).utc.hour} hour flight"
    end
  
    def takeoff_day
      takeoff.strftime('%D')
    end
  
    def takeoff_fmt
      takeoff.strftime('%D at %H:%M')
    end
  end
  