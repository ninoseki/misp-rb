# frozen_string_literal: true

module MISP
  class Attribute < Base
    attr_reader :id
    attr_reader :type
    attr_reader :category
    attr_reader :to_ids
    attr_reader :uuid
    attr_reader :event_id
    attr_reader :distribution
    attr_reader :timestamp
    attr_reader :comment
    attr_reader :sharing_group_id
    attr_reader :deleted
    attr_reader :disable_correlation
    attr_reader :value
    attr_reader :data

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

      @_sharing_groups = attributes.dig(:SharingGroup) || []
      @_shadow_attributes = attributes.dig(:ShadowAttribute) || []
      @_tags = attributes.dig(:Tag) || []
    end

    def sharing_groups
      @sharing_groups ||= @_sharing_groups.map do |attributes|
        SharingGroup.new symbolize_keys(attributes)
      end
    end

    def shadow_attributes
      @shadow_attributes ||= @_shadow_attributes.map do |attributes|
        Attribute.new symbolize_keys(attributes)
      end
    end

    def tags
      @tags ||= @_tags.map do |attributes|
        Tag.new symbolize_keys(attributes)
      end
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
