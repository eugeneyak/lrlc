# frozen_string_literal: true

module Command
  module Extradition
    class Handler
      VIN     = "vin"
      MILEAGE = "mileage"
      PHOTOS  = "photos"
      FINISH  = "Завершить"

      DESTINATIONS = [
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
        when VIN     then handle_vin
        when MILEAGE then handle_mileage
        when PHOTOS  then handle_photos
        end
      end

      def handle_vin
        raise ArgumentError if Helper::VIS.new(message.text).invalid?

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

        unless state.photo_answered
          bot.message message.from, "Пришли еще фотографии или нажми кнопку #{FINISH}",
            reply_markup: {
              keyboard: [ [FINISH] ],
              resize_keyboard: true,
              one_time_keyboard: true,
            }
        end

        state.photo_answered = true
        state.save
      end

      def handle_finish
        caption = <<~TEXT.strip
          [#{message.from.name}](#{message.from.link}) выдал автомобиль
          VIN: #{state.vin}
          Пробег: #{state.mileage}
        TEXT

        DESTINATIONS.each do |dest|
          bot.media_group dest,
            state.photos.first(10).map { {  type: "photo", media: _1, parse_mode: "MarkdownV2" } },
            caption: caption
        end

        bot.message message.from, "Выдача автомобиля завершена",
          reply_markup: {
            remove_keyboard: true,
          }

        state.delete
      end
    end
  end

end
