# frozen_string_literal: true

module Helper
  class VIS
    MATCHER = /^[[:alnum:]]{8}$/

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
      matched = MATCHER === vis

      if matched
        DB.from(:vises)
          .insert_conflict(
            target: :vis,
            update: { last_handled_at: Time.now }
          )
          .insert(vis: vis, last_handled_at: Time.now)
      end

      matched
    end

    def invalid?
      !valid?
    end
  end
end
