module API
  class PingController < APIController
    before_action :find_widget

    def create
      @heartbeat = @widget.widgetable
      @heartbeat.ping!
    end

    private

      def find_widget
        @widget = Current.dashboard.widgets.heartbeats.find_by!(name: params[:name])
      end

  end
end

