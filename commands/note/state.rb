# frozen_string_literal: true

module Command
  module Note
    class State < State::Base
      store :payload, :step, :vin, :note
    end
  end
end
