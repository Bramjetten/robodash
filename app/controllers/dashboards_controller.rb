class DashboardsController < ApplicationController

  def show
    # TODO: add Current.account and get the dashboard using: 
    # Current.account.dashboards.find(params[:id])
    @dashboard = Dashboard.joins(:account).where(account: Current.user.accounts).find(params[:id])
  end

end
