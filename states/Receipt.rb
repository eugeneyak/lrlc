# frozen_string_literal: true

module States
  class Receipt < State
    store :payload, :vin, :photos, :input, :mileage, :photos_answered
  end
end
