# frozen_string_literal: true

module MISP
  class Feed < Base
    # @return [String]
    attr_reader :id
    # @return [String]
    attr_reader :name
    # @return [String]
    attr_reader :provider
    # @return [String]
    attr_reader :url
    # @return [String]
    attr_reader :rules
    # @return [Boolean]
    attr_reader :enabled
    # @return [String]
    attr_reader :distribution
    # @return [String]
    attr_reader :sharing_group_id
    # @return [String]
    attr_reader :tag_id
    # @return [String]
    attr_reader :default
    # @return [String]
    attr_reader :source_format
    # @return [Boolean]
    attr_reader :fixed_event
    # @return [Boolean]
    attr_reader :delta_merge
    # @return [String]
    attr_reader :event_id
    # @return [String]
    attr_reader :publish
    # @return [String]
    attr_reader :override_ids
    # @return [String]
    attr_reader :settings
    # @return [String]
    attr_reader :input_source
    # @return [Boolean]
    attr_reader :delete_local_file
    # @return [Boolean]
    attr_reader :lookup_visible
    # @return [String]
    attr_reader :headers
    # @return [Boolean]
    attr_reader :caching_enabled

    def initialize(**attributes)
      attributes = normalize_attributes(**attributes)

      @id = attributes[:id]
      @name = attributes[:name] || "feed name"
      @provider = attributes[:provider] || "my provider"
      @url = attributes[:url] || "http://example.com"
      @rules = attributes[:rules] || ""
      @enabled = attributes[:enabled]
      @distribution = attributes[:distribution]
      @sharing_group_id = attributes[:sharing_group_id]
      @tag_id = attributes[:tag_id] || "0"
      @default = attributes[:default] || true
      @source_format = attributes[:source_format] || "misp"
      @fixed_event = attributes[:fixed_event] || true
      @delta_merge = attributes[:delta_merge] || false
      @event_id = attributes[:event_id] || "0"
      @publish = attributes[:publish] || true
      @override_ids = attributes[:override_ids] || false
      @settings = attributes[:settings] || ""
      @input_source = attributes[:input_source] || "network"
      @delete_local_file = attributes[:delete_local_file] || false
      @lookup_visible = attributes[:lookup_visible] || true
      @headers = attributes[:headers] || ""
      @caching_enabled = attributes[:caching_enabled] || true
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

    #
    # List feeds
    #
    # @return [Array<MISP::Feed>]
    #
    def list
      _get("/feeds/index") do |feeds|
        feeds.map do |feed|
          Feed.new(**feed)
        end
      end
    end

    #
    # Create a feed
    #
    # @return [MISP::Feed]
    #
    def get
      _get("/feeds/view/#{id}") { |feed| Feed.new feed }
    end

    #
    # Create a feed
    #
    # @param [Hash] **attributes attributes
    #
    # @return [MIPS::Feed]
    #
    def create(**attributes)
      _post("/feeds/add", wrap(attributes)) { |feed| Feed.new feed }
    end

    class << self
      def list
        new.list
      end

      def get(id)
        new(id: id).get
      end

      def create(**attributes)
        new.create attributes
      end
    end
  end
end
