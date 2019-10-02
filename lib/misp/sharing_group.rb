# frozen_string_literal: true

module MISP
  class SharingGroup < Server
    attr_reader :id
    attr_reader :name
    attr_reader :releasability
    attr_reader :description
    attr_reader :uuid
    attr_reader :organisation_uuid
    attr_reader :org_id
    attr_reader :sync_user_id
    attr_reader :active
    attr_reader :created
    attr_reader :modified
    attr_reader :local
    attr_reader :roaming

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

      @_organisation = attributes.dig(:Organisation)

      @sharing_group_orgs = build_plural_attribute(items: attributes.dig(:SharingGroupOrg), klass: SharingGroupOrg)
      @sharing_group_servers = build_plural_attribute(items: attributes.dig(:SharingGroupServer), klass: SharingGroupServer)
    end

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

    def list
      _get("/sharing_groups/") do |res|
        sharing_groups = res.dig("response") || []
        sharing_groups.map do |sharing_group|
          SharingGroup.new sharing_group
        end
      end
    end

    def self.list
      new.list
    end

    def create(**attributes)
      _post("/sharing_groups/add", wrap(attributes)) { |sharing_group| SharingGroup.new sharing_group }
    end

    def self.create(attributes)
      new.create attributes
    end
  end
end
