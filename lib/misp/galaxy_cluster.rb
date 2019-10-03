# frozen_string_literal: true

module MISP
  class GalaxyCluster < Base
    # @return [String]
    attr_reader :id
    # @return [String]
    attr_reader :uuid
    # @return [String]
    attr_reader :type
    # @return [String]
    attr_reader :value
    # @return [String]
    attr_reader :tag_name
    # @return [String]
    attr_reader :description
    # @return [String]
    attr_reader :galaxy_id
    # @return [String]
    attr_reader :source
    # @return [Array<String>]
    attr_reader :authors
    # @return [String]
    attr_reader :tag_id
    # @return [Hash]
    attr_reader :meta

    def initialize(**attributes)
      attributes = normalize_attributes(attributes)

      @id = attributes.dig(:id)
      @uuid = attributes.dig(:uuid)
      @type = attributes.dig(:type)
      @value = attributes.dig(:value)
      @tag_name = attributes.dig(:tag_name)
      @description = attributes.dig(:description)
      @galaxy_id = attributes.dig(:galaxy_id)
      @source = attributes.dig(:source)
      @authors = attributes.dig(:authors)
      @tag_id = attributes.dig(:tag_id)
      @meta = attributes.dig(:meta)
    end

    #
    # Returns a hash representation of the attribute data.
    #
    # @return [Hash]
    #
    def to_h
      {
        id: id,
        uuid: uuid,
        type: type,
        value: value,
        tag_name: tag_name,
        description: description,
        galaxy_id: galaxy_id,
        source: source,
        authors: authors,
        tag_id: tag_id,
        meta: meta,
      }.compact
    end
  end
end
