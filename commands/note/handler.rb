# frozen_string_literal: true

module Command
  module Note
    class Handler
      VIN  = "vin"
      NOTE = "mileage"

      GROUP = -984149820

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

        bot.message GROUP, <<~TEXT.strip
          Заметка от #{message.from.name}
          VIN: #{state.vin}

          #{state.note}
        TEXT

        bot.message message.from, "Заметка создана",
          reply_markup: {
            remove_keyboard: true,
          }
      end

    end
  end

end
