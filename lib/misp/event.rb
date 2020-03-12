# frozen_string_literal: true

module MISP
  class Event < Base
    # @return [String]
    attr_reader :id
    # @return [String]
    attr_accessor :orgc_id
    # @return [String]
    attr_accessor :org_id
    # @return [String]
    attr_accessor :date
    # @return [String]
    attr_accessor :threat_level_id
    # @return [String]
    attr_accessor :info
    # @return [Boolean]
    attr_accessor :published
    # @return [String]
    attr_reader :uuid
    # @return [String]
    attr_accessor :attribute_count
    # @return [String]
    attr_accessor :analysis
    # @return [String]
    attr_accessor :timestamp
    # @return [String]
    attr_accessor :distribution
    # @return [Boolean]
    attr_accessor :proposal_email_lock
    # @return [Boolean]
    attr_accessor :locked
    # @return [String]
    attr_accessor :publish_timestamp
    # @return [String]
    attr_accessor :sharing_group_id
    # @return [Boolean]
    attr_accessor :disable_correlation
    # @return [String]
    attr_accessor :event_creator_email

    # @return [MISP::Org, nil]
    attr_accessor :org
    # @return [MISP::Orgc, nil]
    attr_accessor :orgc

    # @return [Array<MISP::SharingGroup>]
    attr_accessor :sharing_groups
    # @return [Array<MISP::Attribute>]
    attr_accessor :attributes
    # @return [Array<MISP::Attribute>]
    attr_accessor :shadow_attributes
    # @return [Array<MISP::Event>]
    attr_accessor :related_events
    # @return [Array<<MISP::Galaxy>]
    attr_accessor :galaxies
    # @return [Array<<MISP::Tag>]
    attr_accessor :tags

    def initialize(**attrs)
      attrs = normalize_attributes(**attrs)

      @id = attrs.dig(:id)
      @orgc_id = attrs.dig(:orgc_id)
      @org_id = attrs.dig(:org_id)
      @date = attrs.dig(:date)
      @threat_level_id = attrs.dig(:threat_level_id)
      @info = attrs.dig(:info)
      @published = attrs.dig(:published) || false
      @uuid = attrs.dig(:uuid)
      @attribute_count = attrs.dig(:attribute_count)
      @analysis = attrs.dig(:analysis)
      @timestamp = attrs.dig(:timestamp)
      @distribution = attrs.dig(:distribution)
      @proposal_email_lock = attrs.dig(:proposal_email_lock)
      @locked = attrs.dig(:locked) || false
      @publish_timestamp = attrs.dig(:publish_timestamp)
      @sharing_group_id = attrs.dig(:sharing_group_id)
      @disable_correlation = attrs.dig(:disable_correlation)
      @event_creator_email = attrs.dig(:event_creator_email)

      @org = build_attribute(item: attrs.dig(:Org), klass: Org)
      @orgc = build_attribute(item: attrs.dig(:Orgc), klass: Orgc)

      @sharing_groups = build_plural_attribute(items: attrs.dig(:SharingGroup), klass: SharingGroup)
      @attributes = build_plural_attribute(items: attrs.dig(:Attribute), klass: Attribute)
      @shadow_attributes = build_plural_attribute(items: attrs.dig(:ShadowAttribute), klass: Attribute )
      @related_events = build_plural_attribute(items: attrs.dig(:RelatedEvent), klass: Attribute)
      @galaxies = build_plural_attribute(items: attrs.dig(:Galaxy), klass: Galaxy)
      @tags = build_plural_attribute(items: attrs.dig(:Tag), klass: Tag)
    end

    #
    # Returns a hash representation of the attribute data.
    #
    # @return [Hash]
    #
    def to_h
      compact(
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
      )
    end

    #
    # Get an event
    #
    # @return [MISP::Event]
    #
    def get(id)
      _get("/events/#{id}") { |event| Event.new(**event) }
    end

    #
    # Create an event
    #
    # @param [Hash] **attrs attributes
    #
    # @return [MISP::Event]
    #
    def create(**attrs)
      payload = to_h.merge(attrs)
      _post("/events/add", wrap(payload)) { |event| Event.new(**event) }
    end

    #
    # Delete an event
    #
    # @return [Hash]
    #
    def delete
      _delete("/events/#{id}") { |json| json }
    end

    #
    # List events
    #
    # @return [Array<MISP::Event>]
    #
    def list
      _get("/events/index") do |events|
        events.map do |event|
          Event.new(**event)
        end
      end
    end

    #
    # Update an event
    #
    # @return [MISP::Event]
    #
    def update(**attrs)
      payload = to_h.merge(**attrs)
      payload[:timestamp] = nil
      _post("/events/#{id}", wrap(payload)) { |event| Event.new(**event) }
    end

    #
    # Search for events
    #
    # @return [Array<MISP::Event>]
    #
    def search(**params)
      base = {
        returnFormat: "json",
        limit: "100",
        page: "0"
      }

      _post("/events/restSearch", base.merge(params)) do |json|
        events = json.dig(:response) || []
        events.map { |event| Event.new(**event) }
      end
    end

    #
    # Add an attribute to an event. Requires an update or create call afterwards.
    #
    # @return [MISP::Event]
    #
    def add_attribute(attribute)
      attribute = Attribute.new(**attribute) unless attribute.is_a?(Attribute)
      attributes << attribute
      self
    end

    #
    # Add a tag to an event. Requires an update or create call afterwards.
    #
    # @return [MISP::Event]
    #
    def add_tag(tag)
      tag = Tag.new(**tag) unless tag.is_a?(MISP::Tag)
      tags << tag
      self
    end

    class << self
      def get(id)
        new.get id
      end

      def create(**attrs)
        new.create(**attrs)
      end

      def delete(id)
        new(id: id).delete
      end

      def list
        new.list
      end

      def update(id, **attrs)
        new(id: id).update(**attrs)
      end

      def search(**params)
        new.search(**params)
      end
    end

    private

    def compact(hash)
      hash.compact.reject { |_k, v| (v.is_a?(Hash) || v.is_a?(Array)) && v.empty? }
    end
  end
end
