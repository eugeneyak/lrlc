# frozen_string_literal: true

require 'singleton'

module Action
  class Base
    DEFAULT = proc do |message, from|
      p "Unknown action"
      bot.text from, "Кек"
    end

    def self.inherited(action)
      action.instance_variable_set :@commands, { nil: DEFAULT }
      action.instance_variable_set :@message, DEFAULT
      action.instance_variable_set :@photo, DEFAULT
    end

    def self.register(state = State, step: :init)
      Registry.instance.register state, step, self
    end

    def self.message! = @message
    def self.commands! = @commands
    def self.photo! = @photo

    def self.message(&block)
      @message = block.to_proc
    end

    def self.photo(&block)
      @photo = block.to_proc
    end

    def self.command(command = nil, &block)
      @commands[command] = block.to_proc
    end

    def initialize(state)
      @bot   = Telegram::Bot.new
      @state = state
    end

    attr_reader :state, :bot

    def apply(message, from)

      proc =
        case message
        when Telegram::Data::Message
          self.class.message!

        when Telegram::Data::Command
          self.class.commands![message.command] || self.class.commands![nil]

        when Telegram::Data::Photo
          self.class.photo!

        end

      result = self.instance_exec(message, from, &proc)

      case result
      when State
        result.user = from.id
        result.kind = result.class.name
        result.save
      else
        state.save
      end
    end
  end
end
