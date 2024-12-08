module HeartbeatsHelper

  def heartbeat_schedule(heartbeat)
    if heartbeat.schedule_number == 1
      if heartbeat.schedule_period == "day"
        "Daily"
      else
        "#{heartbeat.schedule_period}ly"
      end
    else
      "Every #{heartbeat.schedule_number} #{heartbeat.schedule_period.pluralize}"
    end
  end

end
