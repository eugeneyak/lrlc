# frozen_string_literal: true

class Registry
  include Singleton

  def initialize
    @actions = {}
  end

  attr_reader :actions

  def register(state, step, klass)
    raise ArgumentError, "Duplicate <#{state} #{step}> registration" if find state, step

    actions[[state, step]] = klass
  end

  def find(state, step)
    actions[[state, step]]
  end
end
