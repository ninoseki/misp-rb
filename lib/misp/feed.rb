# frozen_string_literal: true

module MISP
  class Feed < Base
    attr_reader :id
    attr_reader :name
    attr_reader :provider
    attr_reader :url
    attr_reader :rules
    attr_reader :enabled
    attr_reader :distribution
    attr_reader :sharing_group_id
    attr_reader :tag_id
    attr_reader :default
    attr_reader :source_format
    attr_reader :fixed_event
    attr_reader :delta_merge
    attr_reader :event_id
    attr_reader :publish
    attr_reader :override_ids
    attr_reader :settings
    attr_reader :input_source
    attr_reader :delete_local_file
    attr_reader :lookup_visible
    attr_reader :headers
    attr_reader :caching_enabled

    def initialize(**attributes)
      attributes = normalize_attributes(attributes)

      @id = attributes.dig(:id)
      @name = attributes.dig(:name) || "feed name"
      @provider = attributes.dig(:provider) || "my provider"
      @url = attributes.dig(:url) || "http://example.com"
      @rules = attributes.dig(:rules) || ""
      @enabled = attributes.dig(:enabled)
      @distribution = attributes.dig(:distribution)
      @sharing_group_id = attributes.dig(:sharing_group_id)
      @tag_id = attributes.dig(:tag_id) || "0"
      @default = attributes.dig(:default) || true
      @source_format = attributes.dig(:source_format) || "misp"
      @fixed_event = attributes.dig(:fixed_event) || true
      @delta_merge = attributes.dig(:delta_merge) || false
      @event_id = attributes.dig(:event_id) || "0"
      @publish = attributes.dig(:publish) || true
      @override_ids = attributes.dig(:override_ids) || false
      @settings = attributes.dig(:settings) || ""
      @input_source = attributes.dig(:input_source) || "network"
      @delete_local_file = attributes.dig(:delete_local_file) || false
      @lookup_visible = attributes.dig(:lookup_visible) || true
      @headers = attributes.dig(:headers) || ""
      @caching_enabled = attributes.dig(:caching_enabled) || true
    end

    def to_h
      {
        id: id,
        name: name,
        provider: provider,
        url: url,
        rules: rules,
        enabled: enabled,
        distribution: distribution,
        sharing_group_id: sharing_group_id,
        tag_id: tag_id,
        default: default,
        source_format: source_format,
        fixed_event: fixed_event,
        delta_merge: delta_merge,
        event_id: event_id,
        publish: publish,
        override_ids: override_ids,
        settings: settings,
        input_source: input_source,
        delete_local_file: delete_local_file,
        lookup_visible: lookup_visible,
        headers: headers,
        caching_enabled: caching_enabled,
      }.compact
    end

    def list
      _get("/feeds/index") do |feeds|
        feeds.map do |feed|
          Feed.new feed
        end
      end
    end

    def self.list
      new.list
    end

    def get
      _get("/feeds/view/#{id}") { |feed| Feed.new feed }
    end

    def self.get(id)
      new(id: id).get
    end

    def create(**attributes)
      _post("/feeds/add", wrap(attributes)) { |feed| Feed.new feed }
    end

    def self.create(attributes)
      new.create attributes
    end
  end
end
