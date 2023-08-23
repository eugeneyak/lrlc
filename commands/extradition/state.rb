# frozen_string_literal: true

module Command
  module Extradition
    class State < State::Base
      store :payload, :step, :vin, :photos, :mileage, :photo_answered
    end
  end
end
