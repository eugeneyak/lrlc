# frozen_string_literal: true

module Helper
  class VIS
    MATCHER = /[A-Z,0-9]/

    def self.candidates
      DB.from(:vises)
        .order(:last_handled_at)
        .limit(12)
        .select_map(:vis)
        .each_slice(3)
        .to_a
    end

    def initialize(vis)
      @vis = vis
    end

    attr_reader :vis

    def valid?
      match = MATCHER === vis

      if match
        DB.from(:vises)
          .insert_conflict(
            target: :vis,
            update: { last_handled_at: Time.now }
          )
          .insert(vis: vis, last_handled_at: Time.now)
      end

      match
    end

    def invalid?
      !valid?
    end
  end
end
