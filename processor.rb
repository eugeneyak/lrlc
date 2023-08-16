# frozen_string_literal: true

class Processor
  def initialize(message, from)
    @message = message
    @from    = from
  end

  attr_reader :message, :from

  def call
    action.apply message, from
  end

  def action
    state = State.find(user: from.id) || State.create(user: from.id, step: :init)

    ::Registry.instance
      .find(state.class, state.step.to_sym)
      .new(state)
  end
end
