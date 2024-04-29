# frozen_string_literal: true

module Command
  module Maintenance
    class Handler
      ID = "id"
      TYPE = "type"
      BRAND = "brand"
      PHOTOS_BEFORE = "photos_before"
      PHOTOS_AFTER = "photos_after"
      ODOMETER_BEFORE = "odometer_before"
      ODOMETER_AFTER = "odometer_after"
      COST = "cost"

      READY  = "Дальше"

      DESTINATIONS = [
        -1002017175160
      ]

      def initialize(message, state, bot)
        @message = message
        @state   = state
        @bot     = bot
      end

      attr_reader :message, :state, :bot

      def welcome
        state.update(step: ID)

        bot.message message.from, "Введи номер заявки",
          reply_markup: {
            remove_keyboard: true,
          }
      end

      def call
        case state.step
        when ID then handle_id
        when TYPE then handle_type
        when BRAND then handle_brand
        when PHOTOS_BEFORE then handle_photos_before
        when ODOMETER_BEFORE then handle_odometer_before
        when ODOMETER_AFTER then handle_odometer_after
        when PHOTOS_AFTER then handle_photos_after
        when COST then handle_cost
        end
      end

      def handle_id
        state.update(step: TYPE, id: message.text)

        bot.message message.from, "Выбери тип заявки",
          reply_markup: {
            inline_keyboard: [
              [
                { text: "Запуск ДВС", callback_data: "Запуск ДВС" },
                { text: "Замена колеса", callback_data: "Замена колеса" },
              ],
              [
                { text: "Эвакуация Платформа", callback_data: "Эвакуация Платформа" },
                { text: "Эвакуация Манипулятор", callback_data: "Эвакуация Манипулятор" },
              ]
            ]
          }
      end

      def handle_type
        state.update(
          step: BRAND,
          type: message.text,
          needs_odometer: ["Эвакуация Платформа", "Эвакуация Манипулятор"].include?(message.text)
        )

        bot.message message.from, "Записал #{message.text}"
        bot.message message.from, "Марка автомобиля"
      end

      def handle_brand
        state.update(step: PHOTOS_BEFORE, brand: message.text)

        bot.message message.from, "Загрузи фотографии до"
      end

      def handle_photos_before
        return handle_photo_before if message.photo?
        return handle_next_after_photos_before if message.text == READY
      end

      def handle_photo_before
        state.photos_before ||= []
        state.photos_before << message.photo

        unless state.photos_before_answered
          bot.message message.from, "Пришли еще фотографии или нажми кнопку #{READY}",
            reply_markup: {
              keyboard: [ [READY] ],
              resize_keyboard: true,
              one_time_keyboard: true,
            }
        end

        state.photos_before_answered = true
        state.save
      end

      def handle_next_after_photos_before
        if state.needs_odometer
          state.update(step: ODOMETER_BEFORE)
          bot.message message.from, "Значение одометра до",
            reply_markup: {
              remove_keyboard: true,
            }
        else
          state.update(step: PHOTOS_AFTER)
          bot.message message.from, "Загрузи фотографии после",
            reply_markup: {
              remove_keyboard: true,
            }
        end
      end

      def handle_odometer_before
        state.update(step: ODOMETER_AFTER, odometer_before: message.text)
        bot.message message.from, "Значение одометра после"
      end

      def handle_odometer_after
        state.update(step: PHOTOS_AFTER, odometer_after: message.text)
        bot.message message.from, "Загрузи фотографии после"
      end

      def handle_photos_after
        return handle_photo_after if message.photo?
        return handle_next_after_photos_after if message.text == READY
      end

      def handle_photo_after
        state.photos_after ||= []
        state.photos_after << message.photo

        unless state.photos_after_answered
          bot.message message.from, "Пришли еще фотографии или нажми кнопку #{READY}",
            reply_markup: {
              keyboard: [ [READY] ],
              resize_keyboard: true,
              one_time_keyboard: true,
            }
        end

        state.photos_after_answered = true
        state.save
      end

      def handle_next_after_photos_after
        state.update(step: COST)
        bot.message message.from, "Стоимость услуг",
          reply_markup: {
            remove_keyboard: true,
          }
      end

      def handle_cost
        state.update(step: nil, cost: message.text)

        bot.message message.from, "Оформление заявки завершено"

        text = <<~TEXT.strip
          [#{message.from.name}](#{message.from.link}) оформил заявку
          Номер заявки: #{state.id}
          Тип заявки: #{state.type}
          Марка автомобиля: #{state.brand} 
        TEXT

        text += "\n" + <<~TEXT.strip if state.needs_odometer
          Одометр эвакуатора до: #{state.odometer_before}
          Одометр эвакуатора после: #{state.odometer_after}
        TEXT

        text += "\n" + <<~TEXT.strip
          Стоимость услуг: #{state.cost}
        TEXT

        DESTINATIONS.each do |dest|
          bot.message dest, text, parse_mode: "MarkdownV2"

          *images_without_caption, images_with_caption = state.photos_before.each_slice(10).to_a

          images_without_caption.each do |photo_group|
            bot.media_group dest, photo_group.map { {  type: "photo", media: _1 } }
          end

          bot.media_group dest,
            images_with_caption.map { {  type: "photo", media: _1, parse_mode: "MarkdownV2" } },
            caption: "Автомобиль до"

          *images_without_caption, images_with_caption = state.photos_after.each_slice(10).to_a

          images_without_caption.each do |photo_group|
            bot.media_group dest, photo_group.map { {  type: "photo", media: _1 } }
          end

          bot.media_group dest,
            images_with_caption.map { {  type: "photo", media: _1, parse_mode: "MarkdownV2" } },
            caption: "Автомобиль после"
        end

        state.delete
      end
    end
  end
end
