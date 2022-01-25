# frozen_string_literal: true

module MISP
  class Attribute < Base
    # @return [String]
    attr_reader :id
    # @return [String]
    attr_accessor :type
    # @return [String]
    attr_accessor :category
    # @return [Boolean]
    attr_accessor :to_ids
    # @return [String]
    attr_reader :uuid
    # @return [String]
    attr_reader :event_id
    # @return [String]
    attr_accessor :distribution
    # @return [String]
    attr_accessor :timestamp
    # @return [String]
    attr_accessor :comment
    # @return [String]
    attr_accessor :sharing_group_id
    # @return [Boolean]
    attr_accessor :deleted
    # @return [Boolean]
    attr_accessor :disable_correlation
    # @return [String]
    attr_accessor :value
    # @return [String]
    attr_accessor :data

    # @return [Array<MISP::SharingGroup>]
    attr_accessor :sharing_groups
    # @return [Array<MISP::Attribute>]
    attr_accessor :shadow_attributes
    # @return [Array<MISP::Tag>]
    attr_accessor :tags

    def initialize(**attributes)
      attributes = normalize_attributes(**attributes)

      @id = attributes[:id]
      @type = attributes[:type]
      @category = attributes[:category]
      @to_ids = attributes[:to_ids]
      @uuid = attributes[:uuid]
      @event_id = attributes[:event_id]
      @distribution = attributes[:distribution]
      @timestamp = attributes[:timestamp]
      @comment = attributes[:comment]
      @sharing_group_id = attributes[:sharing_group_id]
      @deleted = attributes[:deleted]
      @disable_correlation = attributes[:disable_correlation]
      @value = attributes[:value]
      @data = attributes[:data]

      @sharing_groups = build_plural_attribute(items: attributes[:SharingGroup], klass: SharingGroup)
      @shadow_attributes = build_plural_attribute(items: attributes[:ShadowAttribute], klass: Attribute )
      @tags = build_plural_attribute(items: attributes[:Tag], klass: Tag)
    end

    #
    # Returns a hash representation of the attribute data.
    #
    # @return [Hash]
    #
    def to_h
      {
        id: id,
        type: type,
        category: category,
        to_ids: to_ids,
        uuid: uuid,
        event_id: event_id,
        distribution: distribution,
        timestamp: timestamp,
        comment: comment,
        sharing_group_id: sharing_group_id,
        deleted: deleted,
        disable_correlation: disable_correlation,
        value: value,
        data: data,
        SharingGroup: sharing_groups.map(&:to_h),
        ShadowAttribute: shadow_attributes.map(&:to_h),
        Tag: tags.map(&:to_h)
      }.compact
    end

    #
    # Get an attribute
    #
    # @return [MISP::Attribute]
    #
    def get
      _get("/attributes/#{id}") { |attribute| Attribute.new attribute }
    end

    #
    # Delete an attribute
    #
    # @return [Hash]
    #
    def delete
      _post("/attributes/delete/#{id}") { |json| json }
    end

    #
    # Create an attribute
    #
    # @return [MISP::Attribute]
    #
    def create(event_id)
      _post("/attributes/add/#{event_id}", wrap(to_h)) { |attribute| Attribute.new(**attribute) }
    end

    #
    # Update an attribute
    #
    # @param [Hash] **attrs attributes
    #
    # @return [MISP::Attribute]
    #
    def update(**attrs)
      payload = to_h.merge(attrs)
      payload[:timestamp] = nil
      _post("/attributes/edit/#{id}", wrap(payload)) { |json| Attribute.new(**json.dig(:response, :Attribute)) }
    end

    #
    # Search for attributes
    #
    # @param [Hash] **params parameters
    #
    # @return [Array<MISP::Attributes>]
    #
    def search(**params)
      base = {
        returnFormat: "json",
        limit: "100",
        page: "0"
      }

      _post("/attributes/restSearch", base.merge(params)) do |json|
        attributes = json.dig(:response, :Attribute) || []
        attributes.map { |attribute| Attribute.new(**attribute) }
      end
    end

    #
    # Add a tag to an attribute
    #
    # @param [MISP::Tag, Hash] tag
    #
    # @return [MISP::Tag]
    #
    def add_tag(tag)
      tag = Tag.new(**tag) unless tag.is_a?(MISP::Tag)
      payload = { uuid: uuid, tag: tag.name }
      _post("/tags/attachTagToObject", payload) { |json| Tag.new(**json) }
    end

    #
    # Remove a tag from an attribute
    #
    # @param [MISP::Tag, Hash] tag
    #
    # @return [Hash]
    #
    def remove_tag(tag)
      tag = Tag.new(**tag) unless tag.is_a?(MISP::Tag)
      payload = { uuid: uuid, tag: tag.name }
      _post("/tags/removeTagFromObject", payload) { |json| json }
    end

    class << self
      def get(id)
        new(id: id).get
      end

      def delete(id)
        new(id: id).delete
      end

      def create(event_id, **attributes)
        new(**attributes).create(event_id)
      end

      def search(**params)
        new.search(**params)
      end
    end
  end
end
