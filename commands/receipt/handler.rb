# frozen_string_literal: true

module Command
  module Receipt
    class Handler
      VIN     = "vin"
      MILEAGE = "mileage"
      PHOTOS  = "photos"
      FINISH  = "Завершить"

      def initialize(message, state)
        @message = message
        @state   = state
        @bot     = Telegram::Bot.new
      end

      attr_reader :message, :state, :bot

      def welcome
        state.update(step: VIN)

        bot.message message.from, "Введи VIN"
      end

      def call
        case state.step
        when VIN     then handle_vin
        when MILEAGE then handle_mileage
        when PHOTOS  then handle_photos
        end
      end

      def handle_vin
        raise ArgumentError unless message.text.size == 8

        state.update(step: MILEAGE, vin: message.text)
        bot.message message.from, "Введи пробег"

      rescue ArgumentError
        bot.message message.from, "VIN должен быть длиной ровно 8 символов"
      end

      def handle_mileage
        mileage = Integer(message.text)

        raise ArgumentError if mileage <= 0

        state.update(step: PHOTOS, mileage: mileage)
        bot.message message.from, "Пришли фотографии"

      rescue ArgumentError
        bot.message message.from, "Пробег должен быть числом больше 0"
      end

      def handle_photos
        return handle_photo if message.photo?
        return handle_finish if message.text == FINISH

        raise ArgumentError

      rescue ArgumentError
        bot.message message.from, "Нужна фотография автомобиля"
      end

      def handle_photo
        state.photos ||= []
        state.photos << message.photo
        state.photo_answered = true
        state.save

        unless state.photo_answered
          bot.message message.from, "Пришли еще фотографии или нажми кнопку #{FINISH}",
            reply_markup: {
              keyboard: [ [FINISH] ],
              resize_keyboard: true,
              one_time_keyboard: true,
            }
        end
      end

      def handle_finish
        state.delete

        bot.message message.from, "Красава"
      end
    end
  end

end
