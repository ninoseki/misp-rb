# frozen_string_literal: true

module MISP
  class Attribute < Base
    attr_accessor :id
    attr_accessor :type
    attr_accessor :category
    attr_accessor :to_ids
    attr_accessor :uuid
    attr_accessor :event_id
    attr_accessor :distribution
    attr_accessor :timestamp
    attr_accessor :comment
    attr_accessor :sharing_group_id
    attr_accessor :deleted
    attr_accessor :disable_correlation
    attr_accessor :value
    attr_accessor :data

    attr_accessor :sharing_groups
    attr_accessor :shadow_attributes
    attr_accessor :tags

    def initialize(**attributes)
      attributes = normalize_attributes(attributes)

      @id = attributes.dig(:id)
      @type = attributes.dig(:type)
      @category = attributes.dig(:category)
      @to_ids = attributes.dig(:to_ids)
      @uuid = attributes.dig(:uuid)
      @event_id = attributes.dig(:event_id)
      @distribution = attributes.dig(:distribution)
      @timestamp = attributes.dig(:timestamp)
      @comment = attributes.dig(:comment)
      @sharing_group_id = attributes.dig(:sharing_group_id)
      @deleted = attributes.dig(:deleted)
      @disable_correlation = attributes.dig(:disable_correlation)
      @value = attributes.dig(:value)
      @data = attributes.dig(:data)

      @sharing_groups = build_plural_attribute(items: attributes.dig(:SharingGroup), klass: SharingGroup)
      @shadow_attributes = build_plural_attribute(items: attributes.dig(:ShadowAttribute), klass: Attribute )
      @tags = build_plural_attribute(items: attributes.dig(:Tag), klass: Tag)
    end

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

    def get
      _get("/attributes/#{id}") { |attribute| Attribute.new symbolize_keys(attribute) }
    end

    def self.get(id)
      new(id: id).get
    end

    def delete
      _post("/attributes/delete/#{id}") { |json| json }
    end

    def self.delete(id)
      new(id: id).delete
    end

    def create(event_id)
      _post("/attributes/add/#{event_id}", wrap(to_h)) { |attribute| Attribute.new symbolize_keys(attribute) }
    end

    def self.create(event_id, **attributes)
      new(attributes).create(event_id)
    end

    def update(**attrs)
      payload = to_h.merge(attrs)
      payload[:timestamp] = nil
      _post("/attributes/edit/#{id}", wrap(payload)) { |json| Attribute.new symbolize_keys(json.dig("response", "Attribute")) }
    end

    def search(**params)
      base = {
        returnFormat: "json",
        limit: "100",
        page: "0"
      }

      _post("/attributes/restSearch", base.merge(params)) do |json|
        attributes = json.dig("response", "Attribute") || []
        attributes.map { |attribute| Attribute.new symbolize_keys(attribute) }
      end
    end

    def self.search(**params)
      new.search params
    end

    def add_tag(tag)
      tag = Tag.new(symbolize_keys(tag)) unless tag.is_a?(MISP::Tag)
      payload = { uuid: uuid, tag: tag.name }
      _post("/tags/attachTagToObject", payload) { |json| Tag.new symbolize_keys(json) }
    end

    def remove_tag(tag)
      tag = Tag.new(symbolize_keys(tag)) unless tag.is_a?(MISP::Tag)
      payload = { uuid: uuid, tag: tag.name }
      _post("/tags/removeTagFromObject", payload) { |json| json }
    end
  end
end
