# frozen_string_literal: true

module MISP
  class SharingGroup < Base
    # @return [String]
    attr_reader :id
    # @return [String]
    attr_reader :name
    # @return [String]
    attr_reader :releasability
    # @return [String]
    attr_reader :description
    # @return [String]
    attr_reader :uuid
    # @return [String]
    attr_reader :organisation_uuid
    # @return [String]
    attr_reader :org_id
    # @return [String]
    attr_reader :sync_user_id
    # @return [Boolean]
    attr_reader :active
    # @return [String]
    attr_reader :created
    # @return [String]
    attr_reader :modified
    # @return [Boolean]
    attr_reader :local
    # @return [Boolean]
    attr_reader :roaming

    # @return [MISP::Org, nil]
    attr_reader :organization

    # @return [Array<MISP::SharingGroupOrg>]
    attr_reader :sharing_group_orgs
    # @return [Array<MISP::SharingGroupServer>]
    attr_reader :sharing_group_servers

    def initialize(**attributes)
      attributes = normalize_attributes(attributes)

      @id = attributes.dig(:id)
      @name = attributes.dig(:name) || "default name"
      @releasability = attributes.dig(:releasability) || "default sharability"
      @description = attributes.dig(:description)
      @uuid = attributes.dig(:uuid)
      @organisation_uuid = attributes.dig(:organisation_uuid)
      @org_id = attributes.dig(:org_id)
      @sync_user_id = attributes.dig(:sync_user_id)
      @active = attributes.dig(:active)
      @created = attributes.dig(:created)
      @modified = attributes.dig(:modified)
      @local = attributes.dig(:local)
      @roaming = attributes.dig(:roaming)

      @organisation = build_attribute(item: attributes.dig(:Organization), klass: Org)

      @sharing_group_orgs = build_plural_attribute(items: attributes.dig(:SharingGroupOrg), klass: SharingGroupOrg)
      @sharing_group_servers = build_plural_attribute(items: attributes.dig(:SharingGroupServer), klass: SharingGroupServer)
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
        releasability: releasability,
        description: description,
        uuid: uuid,
        organisation_uuid: organisation_uuid,
        org_id: org_id,
        sync_user_id: sync_user_id,
        active: active,
        created: created,
        modified: modified,
        local: local,
        roaming: roaming,
        Organisation: organisation.to_h,
        SharingGroupOrg: sharing_group_orgs.map(&:to_h),
        SharingGroupServer: sharing_group_servers.map(&:to_h)
      }.compact
    end

    #
    # List sharing groups
    #
    # @return [Array<MISP::SharingGroup>]
    #
    def list
      _get("/sharing_groups/") do |res|
        sharing_groups = res.dig(:response) || []
        sharing_groups.map do |sharing_group|
          SharingGroup.new sharing_group
        end
      end
    end

    #
    # Create a sharing group
    #
    # @param [Hash] **attributes attributes
    #
    # @return [MISP::SharingGroup]
    #
    def create(**attributes)
      _post("/sharing_groups/add", wrap(attributes)) { |sharing_group| SharingGroup.new sharing_group }
    end

    class << self
      def list
        new.list
      end

      def create(**attributes)
        new.create attributes
      end
    end
  end
end
