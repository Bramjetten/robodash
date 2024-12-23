class DashboardsController < ApplicationController

  def show
    @dashboard = Current.user.dashboards.find(params[:id])
  end

end
