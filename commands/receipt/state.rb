# frozen_string_literal: true

module Command
  module Receipt
    class State < State::Base
      store :payload, :step, :vin, :photos, :mileage, :photo_answered
    end
  end
end
