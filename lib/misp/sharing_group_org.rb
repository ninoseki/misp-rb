# frozen_string_literal: true

module MISP
  class SharingGroupOrg < Server
    attr_reader :id
    attr_reader :sharing_group_id
    attr_reader :org_id
    attr_reader :extend

    attr_reader :organization

    def initialize(**attributes)
      attributes = normalize_attributes(attributes)

      @id = attributes.dig(:id)
      @sharing_group_id = attributes.dig(:sharing_group_id)
      @org_id = attributes.dig(:org_id)
      @extend = attributes.dig(:extend)

      @organization = build_attribute(item: attributes.dig(:Organization), klass: Org)
    end

    def to_h
      {
        erver: erver,
        id: id,
        sharing_group_id: sharing_group_id,
        org_id: org_id,
        extend: @extend,
        Organization: organization.to_h
      }.compact
    end
  end
end
