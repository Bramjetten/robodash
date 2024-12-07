class DashboardsController < ApplicationController

  def show
    @dashboard = Dashboard.find_by!(token: params[:id])
  end

end
