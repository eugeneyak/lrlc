# frozen_string_literal: true

class Action::Welcome < Action::Base
  register ::State, step: :init

  command :receipt do |_command, from|
    bot.message(from, "Приемка автомобиля",
      reply_markup: {
        is_persistent: true,
        keyboard: [ ["Ввести VIN", "Загрузить фотографии", "Установить пробег"] ]
      })

    ::States::Receipt.load(step: "init")
  end

  command do |_command, _from|
    p "UNKNOWN COMMAND"
  end
end
