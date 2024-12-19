class DashboardsController < ApplicationController

  def show
    @dashboard = Dashboard.find(params[:id])
  end

end
