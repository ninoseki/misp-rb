# frozen_string_literal: true

module MISP
  class SharingGroupServer < Base
    # @return [String]
    attr_reader :id
    # @return [String]
    attr_reader :sharing_group_id
    # @return [String]
    attr_reader :server_id
    # @return [Boolean]
    attr_reader :all_orgs

    # @return [Array<MISP::Server>]
    attr_reader :servers

    def initialize(**attributes)
      attributes = normalize_attributes(**attributes)

      @id = attributes.dig(:id)
      @sharing_group_id = attributes.dig(:sharing_group_id)
      @server_id = attributes.dig(:server_id)
      @all_orgs = attributes.dig(:all_orgs)

      @servers = build_plural_attribute(items: attributes.dig(:Server), klass: Server)
    end

    #
    # Returns a hash representation of the attribute data.
    #
    # @return [Hash]
    #
    def to_h
      {
        id: id,
        sharing_group_id: sharing_group_id,
        server_id: server_id,
        all_orgs: all_orgs,
        Server: servers.map(&:to_h)
      }.compact
    end
  end
end
