module DashboardHelper

  def issue_count
    @issue_count ||= @dashboard.widgets.down.count
  end

  def warning_count
    @warning_count ||= @dashboard.widgets.warning.count
  end

end

