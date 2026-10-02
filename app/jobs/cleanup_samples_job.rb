class CleanupSamplesJob < ApplicationJob

  def perform
    Sample.where(timestamp: ...25.hours.ago).delete_all

    Reading::RETENTION.each do |type, retention|
      Reading.where(widget: Widget.where(widgetable_type: type)).where(created_at: ...retention.ago).delete_all
    end
    Reading.where.not(widget: Widget.where(widgetable_type: Reading::RETENTION.keys))
      .where(created_at: ...Reading::DEFAULT_RETENTION.ago).delete_all

    StatusChange.where(created_at: ...StatusChange::RETENTION.ago).delete_all
  end

end
