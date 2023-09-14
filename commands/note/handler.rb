# frozen_string_literal: true

module Command
  module Note
    class Handler
      VIN  = "vin"
      NOTE = "mileage"

      DESTINATIONS = [
        -984149820,
        -1001692481789,
      ]

      def initialize(message, state, bot)
        @message = message
        @state   = state
        @bot     = bot
      end

      attr_reader :message, :state, :bot

      def welcome
        state.update(step: VIN)

        bot.message message.from, "Введи VIN",
          reply_markup: {
            keyboard: Helper::VIS.candidates,
            resize_keyboard: true,
            one_time_keyboard: true,
          }
      end

      def call
        case state.step
        when VIN  then handle_vin
        when NOTE then handle_note
        end
      end

      def handle_vin
        raise ArgumentError if Helper::VIS.new(message.text).invalid?

        state.update(step: NOTE, vin: message.text)
        bot.message message.from, "Введи заметку"

      rescue ArgumentError
        bot.message message.from, "VIN должен быть длиной ровно 8 символов"
      end

      def handle_note
        state.update(note: message.text)

        DESTINATIONS.each do |dest|
          bot.message dest, <<~TEXT.strip, parse_mode: "MarkdownV2"
          Заметка от [#{message.from.name}](#{message.from.link})
          VIN: #{state.vin}

          #{state.note}
          TEXT
        end

        bot.message message.from, "Заметка создана",
          reply_markup: {
            remove_keyboard: true,
          }
      end

    end
  end

end
