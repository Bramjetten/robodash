widgetable = widget.widgetable

json.(widget, :id, :name, :alerted_at)
json.type widget.widgetable_type.underscore
json.status widgetable.status
json.warning widgetable.warning?
json.updated_at widgetable.updated_at

case widgetable
when Heartbeat
  json.heartbeat do
    json.(widgetable, :pinged_at, :schedule_number, :schedule_period, :grace_period)
  end
when Counter
  json.counter do
    json.(widgetable, :count, :min, :max)
  end
when UptimeMonitor
  json.uptime_monitor do
    json.(widgetable, :url, :response_code, :response_time)
  end
when Measurement
  json.measurement do
    json.(widgetable, :unit, :value)
    json.samples widgetable.samples.where(timestamp: 25.hours.ago..), :timestamp, :value, :min, :max
  end
end
