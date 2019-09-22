# frozen_string_literal: true

module MISP
  class Org < Base
    attr_reader :id
    attr_reader :name
    attr_reader :uuid

    def initialize(**attributes)
      attributes = normalize_attributes(attributes)

      @id = attributes.dig(:id)
      @name = attributes.dig(:name)
      @uuid = attributes.dig(:uuid)
    end

    def to_h
      {
        id: id,
        name: name,
        uuid: uuid,
      }.compact
    end
  end
end
