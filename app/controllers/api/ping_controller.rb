module API
  class PingController < APIController
    before_action :find_or_create_widget

    def create
      @heartbeat = @widget.widgetable
      @heartbeat.ping!
    end

    private

      def find_or_create_widget
        @widget = Current.dashboard.widgets.heartbeats.where(name: params[:name]).first_or_create(widgetable: Heartbeat.new)
      end

  end
end

