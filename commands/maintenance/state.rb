# frozen_string_literal: true

module Command
  module Maintenance
    class State < State::Base
      store :payload, :step, :id, :type, :brand,
                      :photos_before, :photos_before_answered,
                      :photos_after, :photos_after_answered,
                      :needs_odometer, :odometer_before, :odometer_after,
                      :cost
    end
  end
end
