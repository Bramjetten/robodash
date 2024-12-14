module DashboardHelper

  def issue_count
    @issue_count ||= @dashboard.widgets.to_a.select(&:down?).size
  end

  def warning_count
    @warning_count ||= @dashboard.widgets.to_a.select(&:warning?).size
  end

end

