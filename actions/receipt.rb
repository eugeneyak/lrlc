# frozen_string_literal: true

class Action::Receipt < Action::Base
  register ::States::Receipt, step: :init

  ANSWERS = lambda do |state|
    ans = []

    ans << 'Ввести VIN' unless state.vin
    ans << 'Загрузить фотографии' unless state.photos
    ans << 'Установить пробег' unless state.mileage

    ans << 'Завершить' if ans.size == 0
    ans
  end

  message do |message, from|
    p message

    case message.text
    when 'Завершить'
      bot.media_group -984149820, state.photos.map { |photo| { type: "photo", media: photo } }
      bot.message -984149820, "#{state.vin} #{state.mileage}", reply_markup: {
        remove_keyboard: true
      }

    when 'Ввести VIN', 'Загрузить фотографии', 'Установить пробег'
      state.input = message.text

    else
      case state.input
      when 'Ввести VIN'
        state.input = nil
        state.vin = message.text
        bot.message from, "спс", reply_markup: {
          is_persistent: true,
          keyboard: [ ANSWERS.(state) ]
        }

      when 'Установить пробег'
        state.input = nil
        state.mileage = message.text
        bot.message from, "спс", reply_markup: {
          is_persistent: true,
          keyboard: [ ANSWERS.(state) ]
        }

      else
        bot.message from, "непонятно", reply_markup: {
          is_persistent: true,
          keyboard: [ ANSWERS.(state) ]
        }
      end
    end
  end

  photo do |message, from|
    if state.input == 'Загрузить фотографии'
      state.photos ||= []
      state.photos << message.file_id

      bot.message from, "спс", reply_markup: {
        is_persistent: true,
        keyboard: [ ANSWERS.(state) ]
      }
    else
      bot.message from, "непонятно", reply_markup: {
        is_persistent: true,
        keyboard: [ ANSWERS.(state) ]
      }
    end
  end

  command do |_command, _from|
    p "UNKNOWN COMMAND"
  end
end
