# frozen_string_literal: true

module MISP
  class GalaxyCluster < Base
    attr_reader :id
    attr_reader :uuid
    attr_reader :type
    attr_reader :value
    attr_reader :tag_name
    attr_reader :description
    attr_reader :galaxy_id
    attr_reader :source
    attr_reader :authors
    attr_reader :tag_id
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
