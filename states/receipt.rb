# frozen_string_literal: true

class State::Receipt < State::Base
  store :payload, :vin, :photos, :input, :mileage, :photos_answered
end
