# frozen_string_literal: true

module MISP
  class SharingGroupOrg < Base
    # @return [String]
    attr_reader :id
    # @return [String]
    attr_reader :sharing_group_id
    # @return [String]
    attr_reader :org_id
    # @return [String]
    attr_reader :extend

    # @return [MISP::Organization, nil]
    attr_reader :organization

    def initialize(**attributes)
      attributes = normalize_attributes(attributes)

      @id = attributes.dig(:id)
      @sharing_group_id = attributes.dig(:sharing_group_id)
      @org_id = attributes.dig(:org_id)
      @extend = attributes.dig(:extend)

      @organization = build_attribute(item: attributes.dig(:Organization), klass: Org)
    end

    #
    # Returns a hash representation of the attribute data.
    #
    # @return [Hash]
    #
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
