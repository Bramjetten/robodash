class CleanupSamplesJob < ApplicationJob

  def perform
    Sample.where(timestamp: ...25.hours.ago).delete_all
  end

end
