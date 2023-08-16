# frozen_string_literal: true

require 'sequel'

class State < Sequel::Model
  plugin :class_table_inheritance, key: :kind
  plugin :store_accessors

  unrestrict_primary_key
end
