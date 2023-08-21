# frozen_string_literal: true

module Command
  module Note
    class Handler
      VIN  = "vin"
      NOTE = "mileage"

      GROUP = -984149820

      def initialize(message, state)
        @message = message
        @state   = state
        @bot     = Telegram::Bot.new
      end

      attr_reader :message, :state, :bot

      def welcome
        state.update(step: VIN)

        bot.message message.from, "Введи VIN",
          reply_markup: {
            remove_keyboard: true,
          }
      end

      def call
        case state.step
        when VIN  then handle_vin
        when NOTE then handle_note
        end
      end

      def handle_vin
        raise ArgumentError unless message.text.size == 8

        state.update(step: NOTE, vin: message.text)
        bot.message message.from, "Введи заметку"

      rescue ArgumentError
        bot.message message.from, "VIN должен быть длиной ровно 8 символов"
      end

      def handle_note
        state.update(note: message.text)

        bot.message message.from, "Заметка создана",
          reply_markup: {
            remove_keyboard: true,
          }

        bot.message GROUP, <<~TEXT.strip
          Заметка от #{message.from.name}
          VIN: #{state.vin}

          #{state.note}
        TEXT
      end

    end
  end

end
