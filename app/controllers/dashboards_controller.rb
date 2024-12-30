class DashboardsController < ApplicationController
  before_action :set_dashboard

  def show
  end

  def edit
  end

  def update
    if @dashboard.update(dashboard_params)
      redirect_back fallback_location: @dashboard
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def set_dashboard
      @dashboard = Current.user.dashboards.find(params[:id])
    end

    def dashboard_params
      params.expect(dashboard: [:name])
    end

end
