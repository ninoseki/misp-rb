# frozen_string_literal: true

module MISP
  class Orgc < Base
    # @return [String]
    attr_reader :id
    # @return [String]
    attr_reader :name
    # @return [String]
    attr_reader :uuid

    def initialize(**attributes)
      attributes = normalize_attributes(**attributes)

      @id = attributes[:id]
      @name = attributes[:name]
      @uuid = attributes[:uuid]
    end

    #
    # Returns a hash representation of the attribute data.
    #
    # @return [Hash]
    #
    def to_h
      {
        id: id,
        name: name,
        uuid: uuid,
      }.compact
    end
  end
end
