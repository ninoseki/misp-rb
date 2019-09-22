# frozen_string_literal: true

module MISP
  class Event < Base
    attr_reader :id
    attr_reader :orgc_id
    attr_reader :org_id
    attr_reader :date
    attr_reader :threat_level_id
    attr_reader :info
    attr_reader :published
    attr_reader :uuid
    attr_reader :attribute_count
    attr_reader :analysis
    attr_reader :timestamp
    attr_reader :distribution
    attr_reader :proposal_email_lock
    attr_reader :locked
    attr_reader :publish_timestamp
    attr_reader :sharing_group_id
    attr_reader :disable_correlation
    attr_reader :event_creator_email

    def initialize(**attributes)
      attributes = normalize_attributes(attributes)

      @id = attributes.dig(:id)
      @orgc_id = attributes.dig(:orgc_id)
      @org_id = attributes.dig(:org_id)
      @date = attributes.dig(:date)
      @threat_level_id = attributes.dig(:threat_level_id)
      @info = attributes.dig(:info)
      @published = attributes.dig(:published) || false
      @uuid = attributes.dig(:uuid)
      @attribute_count = attributes.dig(:attribute_count)
      @analysis = attributes.dig(:analysis)
      @timestamp = attributes.dig(:timestamp)
      @distribution = attributes.dig(:distribution)
      @proposal_email_lock = attributes.dig(:proposal_email_lock)
      @locked = attributes.dig(:locked) || false
      @publish_timestamp = attributes.dig(:publish_timestamp)
      @sharing_group_id = attributes.dig(:sharing_group_id)
      @disable_correlation = attributes.dig(:disable_correlation)
      @event_creator_email = attributes.dig(:event_creator_email)

      @_org = attributes.dig(:Org)
      @_orgc = attributes.dig(:Orgc)

      @_sharing_groups = attributes.dig(:SharingGroup) || []
      @_attributes = attributes.dig(:Attribute) || []
      @_shadow_attributes = attributes.dig(:ShadowAttribute) || []
      @_related_events = attributes.dig(:RelatedEvent) || []
      @_galaxies = attributes.dig(:Galaxy) || []
      @_tags = attributes.dig(:Tag) || []
    end

    def org
      @org ||= @_org ? Org.new(symbolize_keys(@_org)) : nil
    end

    def orgc
      @orgc ||= @_orgc ? Orgc.new(symbolize_keys(@_orgc)) : nil
    end

    def sharing_groups
      @sharing_groups ||= @_sharing_groups.map do |attributes|
        SharingGroup.new symbolize_keys(attributes)
      end
    end

    def attributes
      @attributes ||= @_attributes.map do |attributes|
        Attribute.new symbolize_key(attributes)
      end
    end

    def shadow_attributes
      @shadow_attributes ||= @_shadow_attributes.map do |attributes|
        Attribute.new symbolize_keys(attributes)
      end
    end

    def related_events
      @related_events ||= @_related_events.map do |attributes|
        new symbolize_keys(attributes)
      end
    end

    def galaxies
      @galaxies ||= @_galaxies.map do |attributes|
        Galaxy.new symbolize_keys(attributes)
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
        orgc_id: orgc_id,
        org_id: org_id,
        date: date,
        threat_level_id: threat_level_id,
        info: info,
        published: published,
        uuid: uuid,
        attribute_count: attribute_count,
        analysis: analysis,
        timestamp: timestamp,
        distribution: distribution,
        proposal_email_lock: proposal_email_lock,
        locked: locked,
        publish_timestamp: publish_timestamp,
        sharing_group_id: sharing_group_id,
        disable_correlation: disable_correlation,
        event_creator_email: event_creator_email,
        Org: org.to_h,
        Orgc: orgc.to_h,
        SharingGroup: sharing_groups.map(&:to_h),
        Attribute: attributes.map(&:to_h),
        ShadowAttribute: shadow_attributes.map(&:to_h),
        RelatedEvent: related_events.map(&:to_h),
        Galaxy: galaxies.map(&:to_h),
        Tag: tags.map(&:to_h)
      }.compact
    end

    def get(id)
      _get("/events/#{id}") { |event| Event.new symbolize_keys(event) }
    end

    def self.get(id)
      new.get id
    end

    def create(**attributes)
      _post("/events/add", wrap(attributes)) { |event| Event.new symbolize_keys(event) }
    end

    def self.create(attributes)
      new.create attributes
    end

    def delete
      _delete("/events/#{id}") { |json| json }
    end

    def self.delete(id)
      new(id: id).delete
    end

    def list
      _get("/events/index") do |events|
        events.map do |event|
          Event.new symbolize_keys(event)
        end
      end
    end

    def self.list
      new.list
    end

    def update(attributes)
      attributes[:timestamp] = nil
      _post("/events/#{id}", wrap(attributes)) { |event| Event.new symbolize_keys(event) }
    end

    def self.update(id, **attributes)
      new(id: id).update attributes
    end

    def search(**params)
      base = {
        returnFormat: "json",
        limit: "100",
        page: "0"
      }

      _post("/events/restSearch", base.merge(params)) do |json|
        events = json.dig("response") || []
        events.map { |event| Event.new symbolize_keys(event) }
      end
    end

    def self.search(**params)
      new.search params
    end

    def add_attribute(attribute)
      attribute = attribute.new(symbolize_keys(attribute)) unless attribute.is_a?(Attribute)

      hash = to_h
      hash[:Attribute] += [attribute.to_h]

      update(hash)
    end

    def add_tag(tag)
      tag = Tag.new(symbolize_keys(tag)) unless tag.is_a?(MISP::Tag)

      hash = to_h
      hash[:Tag] += [tag.to_h]

      update(hash)
    end
  end
end
