# frozen_string_literal: true

require 'sequel'

module State
  class Base < Sequel::Model(:states)
    plugin :class_table_inheritance, key: :kind
    plugin :store_accessors

    unrestrict_primary_key
  end
end
