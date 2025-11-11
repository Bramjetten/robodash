class CleanupSamplesJob < ApplicationJob

  def perform
    Sample.where(timestamp: ...Measurement::SAMPLE_WINDOW.ago).delete_all
  end

end
