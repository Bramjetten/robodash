# POST api/v1/push_device
# Body:
# - token (required): APNs device token
# - name: device model, e.g. iPhone18,4
#
# Registers the device for push notifications for the current session
module API
  module V1
    class PushDevicesController < BaseController

      def create
        device = ApplicationPushDevice.find_or_initialize_by(token: params.require(:token))

        # The same device can sign in again (or as someone else), so it moves to the new session
        if device.update(owner: Current.session, platform: "apple", name: params[:name])
          head :no_content
        else
          render json: { errors: device.errors.full_messages }, status: :unprocessable_entity
        end
      end

    end
  end
end
