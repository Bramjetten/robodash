class DashboardsController < ApplicationController

  def show
    @dashboard = Dashboard.joins(:account).where(account: Current.user.accounts).find(params[:id])
  end

end
